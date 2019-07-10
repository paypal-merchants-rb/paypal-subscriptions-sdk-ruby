module PayPal::SDK::Subscriptions
  # v1/billing/plans
  class Plan < RequestBase

    class BillingCycle < Base
      class Frequency < Base
        object_of :interval_unit, String
        object_of :interval_count, Integer
      end

      class PricingScheme < Base
        object_of :version, Integer
        object_of :fixed_price, Money
        object_of :create_time, DateTime
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

    def create
      response = api.post(self.class.path, self.to_hash, http_header)
      self.merge!(response)
      success?
    end

    # https://developer.paypal.com/docs/api/subscriptions/v1/#plans_patch
    # patch [Hash] { op: 'replace', path: , value: }
    # path = [description|payment_preferences.auto_bill_outstanding|taxes.percentage|payment_preferences.payment_failure_threshold]
    def update(patch)
      patch = Patch.new(patch) unless patch.is_a? Patch
      response = api.patch(self.class.path(id), [patch.to_hash], http_header)
      self.merge!(response)
      success?
    end

    def update_pricing(*schemes)
      path = "#{self.class.path(id)}/update-pricing-schemes"
      payload = { pricing_schemes: schemes.map(&:to_hash) }
      merge! api.post(path, payload, http_header)
      success?
    end
    raise_on_api_error :update_pricing

    def activate
      path = "#{self.class.path(id)}/activate"
      merge! api.post(path, {}, http_header)
      success?
    end
    raise_on_api_error :activate

    def deactivate
      path = "#{self.class.path(id)}/deactivate"
      merge! api.post(path, {}, http_header)
      success?
    end
    raise_on_api_error :deactivate

    raise_on_api_error :create, :update

    class Page < RequestBase
      object_of :total_items, Integer
      object_of :total_pages, Integer
      array_of :plans, Plan
      array_of :links, Link # self, next, last

      def next
        link = links.detect { |l| l.rel == 'next' }
        if link
          uri = URI.parse(link.href)
          response = api.api_call(method: :get, uri: uri, header: {})
          self.class.new(response)
        end
      end
    end

    class << self
      def path(resource_id = nil)
        "v1/billing/plans/#{resource_id}"
      end

      def find(resource_id)
        raise ArgumentError.new("id required") if resource_id.to_s.strip.empty?
        new(api.get(path resource_id))
      end

      # options include 'page', 'page_size', and 'total_required'
      def all(options = {})
        Page.new(api.get(path, options))
      end
    end

    def reload
      merge! api.get(self.class.path id)
      success?
    end

    object_of :product_id, String
    object_of :id, String
    object_of :name, String
    object_of :description, String
    object_of :status, String # CREATED|ACTIVE|INACTIVE
    array_of  :billing_cycles, BillingCycle
    object_of :payment_preferences, PaymentPreferences
    object_of :quantity_supported, Boolean
    object_of :taxes, Taxes
    object_of :create_time, String
    object_of :update_time, String
    array_of  :links, Link
  end
end
