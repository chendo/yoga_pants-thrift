require 'addressable/uri'
require 'yoga_pants/transport/thrift/rest'

module YogaPants
  class Transport
    class Thrift < Base
      attr_reader :uri, :options, :client

      private :client

      class ThriftError < TransportError
        def initialize(message, response = nil)
          @response    = response
          if response
            @status_code = response.status
            super(message + "\nBody: #{response.body}")
          else
            super(message)
          end
        end
      end

      DEFAULT_OPTIONS = {
        :timeout => 5,
        :thrift => {
          :protocol => ::Thrift::BinaryProtocol,
          :protocol_args => [],
          :transport => ::Thrift::Socket,
          :transport_wrapper => ::Thrift::BufferedTransport
        }
      }

      def initialize(uri, options = {})
        @uri = uri
        @options = DEFAULT_OPTIONS.merge(options || {})

        thrift_options = @options[:thrift]

        @transport = thrift_options[:transport].new(uri.host, uri.port, @options[:timeout])
        @transport = thrift_options[:transport_wrapper].new(@transport)
        # TODO: Look at wrapping transport
        @transport.open

        protocol = thrift_options[:protocol].new(@transport, *thrift_options[:protocol_args])
        @client = ElasticSearch::Thrift::Rest::Client.new(protocol)

        @mutex = Mutex.new
      end

      def get(path, args = {})
        parse_arguments_and_handle_response(args) do |query_string, body|
          request(:get, path, query_string, body)
        end
      end

      def post(path, args = {})
        parse_arguments_and_handle_response(args) do |query_string, body|
          request(:post, path, query_string, body)
        end
      end

      def put(path, args = {})
        parse_arguments_and_handle_response(args) do |query_string, body|
          request(:put, path, query_string, body)
        end
      end

      def delete(path, args = {})
        parse_arguments_and_handle_response(args) do |query_string, body|
          request(:delete, path, query_string, body)
        end
      end

      def head(path, args = {})
        parse_arguments_and_handle_response(args) do |query_string, body|
          request(:head, path, query_string, body)
        end
      end

      def exists?(path, args = {})
        head(path, args)
        true
      rescue ThriftError => e
        if e.status_code == 404
          false
        else
          raise
        end
      end

      protected

      REQUEST_METHODS = {
        :get => ElasticSearch::Thrift::Method::GET,
        :post => ElasticSearch::Thrift::Method::POST,
        :put => ElasticSearch::Thrift::Method::PUT,
        :delete => ElasticSearch::Thrift::Method::DELETE,
        :head => ElasticSearch::Thrift::Method::HEAD
      }

      def request(method, path, query_string = nil, body = nil)
        request = ElasticSearch::Thrift::RestRequest.new
        request.method = REQUEST_METHODS[method]
        request.uri = path
        request.parameters = query_string_to_hash(query_string)
        request.body = body

        with_error_handling do
          @mutex.synchronize do
            client.execute(request)
          end
        end
      end

      def parse_and_handle_response(response)
        case response.status
        when 200..299
          response.body && JSON.load(response.body)
        else
          raise ThriftError.new("Error performing Thrift Request", response)
        end
      end

      def with_error_handling(&block)
        begin
          block.call
        rescue => e
          $stderr.puts("EXCEPTION IN THREAD: #{Thread.current}")
          $stderr.puts("Transport: #{@transport}")
          raise
        end
      end

      def query_string_to_hash(query_string)
        return query_string if query_string.is_a?(Hash)
        uri = Addressable::URI.new
        uri.query = query_string
        uri.query_values
      end
    end
  end

  Transport.register_transport(YogaPants::Transport::Thrift, 'thrift')
end
