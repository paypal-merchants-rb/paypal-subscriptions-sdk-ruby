module PayPal::SDK::Subscriptions
  # v1/billing/plans
  class Plan < Base

    class BillingCycle < Base
      class Frequency < Base
        object_of :interval_unit, String
        object_of :interval_count, Integer
      end

      class PricingScheme < Base
        object_of :fixed_price, Money
      end

      object_of :frequency, Frequency
      object_of :tenure_type, String
      object_of :sequence, Integer
      object_of :total_cycles, Integer
      object_of :pricing_scheme, PricingScheme
    end

    # https://developer.paypal.com/docs/api/subscriptions/v1/#definition-payment_preferences
    class PaymentPreferences < Base
      object_of :service_type, String
      object_of :auto_bill_outstanding, Boolean # default: true
      object_of :setup_fee, Money
      object_of :setup_fee_failure_action, String # CANCEL(default)|CONTINUE
      object_of :payment_failure_threshold, Integer # default: 0
    end

    class Taxes < Base
      object_of :percentage, Number
      object_of :inclusive, Boolean
    end

    include RequestDataType

    def create
      path = "v1/billing/plans/"
      response = api.post(path, self.to_hash, http_header)
      self.merge!(response)
      success?
    end

    object_of :product_id, String
    object_of :id, String
    object_of :name, String
    object_of :description, String
    object_of :status, String
    array_of  :billing_cycles, BillingCycle
    object_of :payment_preferences, PaymentPreferences
    object_of :quantity_supported, Boolean
    object_of :taxes, Taxes
    array_of  :links, Links
  end
end
