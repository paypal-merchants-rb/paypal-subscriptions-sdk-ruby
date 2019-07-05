module PayPal
  module SDK
    module Subscriptions
      module GetAPI
        # Get API object
        # === Example
        #   Payment.api
        #   payment.api
        def api
          @api || parent_api
        end

        # Parent API object
        def parent_api
          superclass.respond_to?(:api) ? superclass.api : RequestDataType.api
        end
      end

      class API < Core::API::REST
        def initialize(environment = nil, options = {})
          super("", environment, options)
        end

        class << self
          def user_agent
            @user_agent ||= "PayPalSDK/PayPal-Subscriptions-Ruby-SDK #{PayPal::SDK::Subscriptions::VERSION} (#{sdk_library_details})"
          end
        end
      end

      module RequestDataType
        # Get a local API object or Class level API object
        def api
          @api || self.class.api
        end

        # Convert Hash object to ErrorHash object
        def error=(hash)
          @error =
            if hash.is_a? Hash
              ErrorHash.convert(hash)
            else
              hash
            end
        end

        class << self
          # Global API object
          # === Example
          #   RequestDataType.api
          def api
            @api ||= API.new
          end

          # Configure depended module, when RequestDataType is include.
          # === Example
          #   class Payment < DataTypes
          #     include RequestDataType
          #   end
          #   Payment.api
          #   payment.api
          def included(klass)
            klass.class_eval do
              extend GetAPI
            end
          end
        end
      end
    end
  end
end
