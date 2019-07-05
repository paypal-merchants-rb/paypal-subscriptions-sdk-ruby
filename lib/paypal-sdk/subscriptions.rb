require 'paypal-sdk-core'

module PayPal
  module SDK
    module Subscriptions
      class Error < StandardError; end

      autoload :VERSION,   "paypal-sdk/subscriptions/version"
      autoload :Base,      "paypal-sdk/subscriptions/data_types"
      autoload :ErrorHash, "paypal-sdk/subscriptions/error_hash"
      autoload :RequestDataType, "paypal-sdk/subscriptions/request_data_type"

      autoload :Product,   "paypal-sdk/subscriptions/product"
      autoload :Products,  "paypal-sdk/subscriptions/product"
    end
  end
end
