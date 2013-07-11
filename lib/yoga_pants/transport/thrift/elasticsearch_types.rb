module ElasticSearch
  module Thrift
        module Method
          GET = 0
          PUT = 1
          POST = 2
          DELETE = 3
          HEAD = 4
          OPTIONS = 5
          VALUE_MAP = {0 => "GET", 1 => "PUT", 2 => "POST", 3 => "DELETE", 4 => "HEAD", 5 => "OPTIONS"}
          VALID_VALUES = Set.new([GET, PUT, POST, DELETE, HEAD, OPTIONS]).freeze
        end

        module Status
          CONT = 100
          SWITCHING_PROTOCOLS = 101
          OK = 200
          CREATED = 201
          ACCEPTED = 202
          NON_AUTHORITATIVE_INFORMATION = 203
          NO_CONTENT = 204
          RESET_CONTENT = 205
          PARTIAL_CONTENT = 206
          MULTI_STATUS = 207
          MULTIPLE_CHOICES = 300
          MOVED_PERMANENTLY = 301
          FOUND = 302
          SEE_OTHER = 303
          NOT_MODIFIED = 304
          USE_PROXY = 305
          TEMPORARY_REDIRECT = 307
          BAD_REQUEST = 400
          UNAUTHORIZED = 401
          PAYMENT_REQUIRED = 402
          FORBIDDEN = 403
          NOT_FOUND = 404
          METHOD_NOT_ALLOWED = 405
          NOT_ACCEPTABLE = 406
          PROXY_AUTHENTICATION = 407
          REQUEST_TIMEOUT = 408
          CONFLICT = 409
          GONE = 410
          LENGTH_REQUIRED = 411
          PRECONDITION_FAILED = 412
          REQUEST_ENTITY_TOO_LARGE = 413
          REQUEST_URI_TOO_LONG = 414
          UNSUPPORTED_MEDIA_TYPE = 415
          REQUESTED_RANGE_NOT_SATISFIED = 416
          EXPECTATION_FAILED = 417
          UNPROCESSABLE_ENTITY = 422
          LOCKED = 423
          FAILED_DEPENDENCY = 424
          INTERNAL_SERVER_ERROR = 500
          NOT_IMPLEMENTED = 501
          BAD_GATEWAY = 502
          SERVICE_UNAVAILABLE = 503
          GATEWAY_TIMEOUT = 504
          INSUFFICIENT_STORAGE = 506
          VALUE_MAP = {100 => "CONT", 101 => "SWITCHING_PROTOCOLS", 200 => "OK", 201 => "CREATED", 202 => "ACCEPTED", 203 => "NON_AUTHORITATIVE_INFORMATION", 204 => "NO_CONTENT", 205 => "RESET_CONTENT", 206 => "PARTIAL_CONTENT", 207 => "MULTI_STATUS", 300 => "MULTIPLE_CHOICES", 301 => "MOVED_PERMANENTLY", 302 => "FOUND", 303 => "SEE_OTHER", 304 => "NOT_MODIFIED", 305 => "USE_PROXY", 307 => "TEMPORARY_REDIRECT", 400 => "BAD_REQUEST", 401 => "UNAUTHORIZED", 402 => "PAYMENT_REQUIRED", 403 => "FORBIDDEN", 404 => "NOT_FOUND", 405 => "METHOD_NOT_ALLOWED", 406 => "NOT_ACCEPTABLE", 407 => "PROXY_AUTHENTICATION", 408 => "REQUEST_TIMEOUT", 409 => "CONFLICT", 410 => "GONE", 411 => "LENGTH_REQUIRED", 412 => "PRECONDITION_FAILED", 413 => "REQUEST_ENTITY_TOO_LARGE", 414 => "REQUEST_URI_TOO_LONG", 415 => "UNSUPPORTED_MEDIA_TYPE", 416 => "REQUESTED_RANGE_NOT_SATISFIED", 417 => "EXPECTATION_FAILED", 422 => "UNPROCESSABLE_ENTITY", 423 => "LOCKED", 424 => "FAILED_DEPENDENCY", 500 => "INTERNAL_SERVER_ERROR", 501 => "NOT_IMPLEMENTED", 502 => "BAD_GATEWAY", 503 => "SERVICE_UNAVAILABLE", 504 => "GATEWAY_TIMEOUT", 506 => "INSUFFICIENT_STORAGE"}
          VALID_VALUES = Set.new([CONT, SWITCHING_PROTOCOLS, OK, CREATED, ACCEPTED, NON_AUTHORITATIVE_INFORMATION, NO_CONTENT, RESET_CONTENT, PARTIAL_CONTENT, MULTI_STATUS, MULTIPLE_CHOICES, MOVED_PERMANENTLY, FOUND, SEE_OTHER, NOT_MODIFIED, USE_PROXY, TEMPORARY_REDIRECT, BAD_REQUEST, UNAUTHORIZED, PAYMENT_REQUIRED, FORBIDDEN, NOT_FOUND, METHOD_NOT_ALLOWED, NOT_ACCEPTABLE, PROXY_AUTHENTICATION, REQUEST_TIMEOUT, CONFLICT, GONE, LENGTH_REQUIRED, PRECONDITION_FAILED, REQUEST_ENTITY_TOO_LARGE, REQUEST_URI_TOO_LONG, UNSUPPORTED_MEDIA_TYPE, REQUESTED_RANGE_NOT_SATISFIED, EXPECTATION_FAILED, UNPROCESSABLE_ENTITY, LOCKED, FAILED_DEPENDENCY, INTERNAL_SERVER_ERROR, NOT_IMPLEMENTED, BAD_GATEWAY, SERVICE_UNAVAILABLE, GATEWAY_TIMEOUT, INSUFFICIENT_STORAGE]).freeze
        end

        class RestRequest
          include ::Thrift::Struct, ::Thrift::Struct_Union
          METHOD = 1
          URI = 2
          PARAMETERS = 3
          HEADERS = 4
          BODY = 5

          FIELDS = {
            METHOD => {:type => ::Thrift::Types::I32, :name => 'method', :enum_class => ElasticSearch::Thrift::Method},
            URI => {:type => ::Thrift::Types::STRING, :name => 'uri'},
            PARAMETERS => {:type => ::Thrift::Types::MAP, :name => 'parameters', :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::STRING}, :optional => true},
            HEADERS => {:type => ::Thrift::Types::MAP, :name => 'headers', :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::STRING}, :optional => true},
            BODY => {:type => ::Thrift::Types::STRING, :name => 'body', :binary => true, :optional => true}
          }

          def struct_fields; FIELDS; end

          def validate
            raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field method is unset!') unless @method
            raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field uri is unset!') unless @uri
            unless @method.nil? || ElasticSearch::Thrift::Method::VALID_VALUES.include?(@method)
              raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field method!')
            end
          end

          ::Thrift::Struct.generate_accessors self
        end

        class RestResponse
          include ::Thrift::Struct, ::Thrift::Struct_Union
          STATUS = 1
          HEADERS = 2
          BODY = 3

          FIELDS = {
            STATUS => {:type => ::Thrift::Types::I32, :name => 'status', :enum_class => ElasticSearch::Thrift::Status},
            HEADERS => {:type => ::Thrift::Types::MAP, :name => 'headers', :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::STRING}, :optional => true},
            BODY => {:type => ::Thrift::Types::STRING, :name => 'body', :binary => true, :optional => true}
          }

          def struct_fields; FIELDS; end

          def validate
            raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field status is unset!') unless @status
            unless @status.nil? || ElasticSearch::Thrift::Status::VALID_VALUES.include?(@status)
              raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field status!')
            end
          end

          ::Thrift::Struct.generate_accessors self
        end

      end
    end
