require 'yoga_pants/transport/thrift/rest'

module YogaPants
  class Transport
    class Thrift < Base
      attr_reader :uri, :options, :client

      private :client

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

        thrift_options = options[:thrift]

        transport = thrift_options[:transport].new(uri.host, uri.port, options[:timeout])
        # TODO: Look at wrapping transport
        transport.open

        protocol = options[:thrift][:protocol].new(transport, *thrift_options[:protocol_args])
        @client = ElasticSearch::Thrift::Rest::Client.new(protocol)
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

      protected

      REQUEST_METHODS = {
        :get => ElasticSearch::Thrift::Method::GET,
        :post => ElasticSearch::Thrift::Method::POST,
        :put => ElasticSearch::Thrift::Method::PUT,
        :delete => ElasticSearch::Thrift::Method::DELETE
      }

      def request(method, path, query_string = nil, body = nil)
        request = ElasticSearch::Thrift::Request.new
        request.method = REQUEST_METHODS[:method]
        request.uri = path
        request.parameters = query_string_to_hash(query_string)
        request.body = body

        client.execute(request)
      end

      def parse_and_handle_response(response)
        case response.status
        when 200..299
          JSON.load(response.body)
        else
          raise TransportError.new("Error performing Thrift Request: #{response.status}")
        end
      end

      def query_string_to_hash(query_string)
        uri = Addressable::URI.new
        uri.query = query_string
        uri.query_values
      end

      def memcached_key_for(path, query_string = nil, body = nil)
        uri = Addressable::URI.new
        uri.path = path
        uri.query = query_string || ''
        if body
          uri.query_values.merge!(:source => body)
        end
        uri.to_s
      end
    end
  end

  Transport.register_transport(Thrift, 'thrift')
end
