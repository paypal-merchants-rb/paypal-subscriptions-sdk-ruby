require 'paypal-sdk-core'

module PayPal
  module SDK
    module Subscriptions
      class Error < StandardError; end

      autoload :VERSION,   "paypal-sdk/subscriptions/version"
      autoload :Base,      "paypal-sdk/subscriptions/data_types"
      autoload :ErrorHash, "paypal-sdk/subscriptions/error_hash"
      autoload :RequestDataType, "paypal-sdk/subscriptions/request_data_type"

      autoload :BillingPlan, "paypal-sdk/subscriptions/billing_plan"
      autoload :Product,   "paypal-sdk/subscriptions/product"
      autoload :Subscription, "paypal-sdk/subscriptions/subscription"
    end
  end
end
