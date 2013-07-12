require 'yoga_pants/transport/thrift/rest'

module YogaPants
  class Transport
    class Thrift < Base
      class Connection
        # This class wraps the Thrift REST client and socket
        # It will handle socket disconnections etc

        def initialize(host, port, options)
          @transport = options[:transport].new(host, port, options[:timeout])
          @transport = options[:transport_wrapper].new(@transport) if options[:transport_wrapper]
          @transport.open

          protocol = options[:protocol].new(@transport, *options[:protocol_args])
          @client = ElasticSearch::Thrift::Rest::Client.new(protocol)
        end

        SOCKET_RETRY_COUNT = 3
        def execute(*args)
          tries_remaining = SOCKET_RETRY_COUNT
          @client.execute(*args)
        rescue IOError
          if tries_remaining.zero?
            raise
          else
            tries_remaining -= 1
            @transport.open
            retry
          end
        end
      end
    end
  end
end
