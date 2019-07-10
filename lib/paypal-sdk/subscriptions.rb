require 'paypal-sdk-core'

module PayPal
  module SDK
    module Subscriptions
      class Error < StandardError; end

      autoload :VERSION,   "paypal-sdk/subscriptions/version"
      autoload :Base,      "paypal-sdk/subscriptions/data_types"
      autoload :ErrorHash, "paypal-sdk/subscriptions/error_hash"
      autoload :Link,      "paypal-sdk/subscriptions/link"
      autoload :RequestBase, "paypal-sdk/subscriptions/request_base"
      autoload :RequestDataType, "paypal-sdk/subscriptions/request_data_type"

      autoload :Plan, "paypal-sdk/subscriptions/plan"
      autoload :Product,   "paypal-sdk/subscriptions/product"
      autoload :Subscription, "paypal-sdk/subscriptions/subscription"
    end
  end
end
