module PayPal::SDK::Subscriptions
  # https://developer.paypal.com/docs/api/subscriptions/v1/#subscriptions
  class Subscription < RequestBase

    def create()
      path = "v1/billing/subscriptions/"
      response = api.post(path, self.to_hash, http_header)
      self.merge!(response)
      success?
    end

    class Subscriber < Base
      class SubscriberName < Base
        object_of :given_name, String
        object_of :surname, String
      end

      class ShippingAddress < Base
        class BaseAddress < Base
          object_of :address_line_1, String
          object_of :address_line_2, String
          object_of :admin_area_2, String
          object_of :admin_area_1, String
          object_of :postal_code, String
          object_of :country_code, String
        end

        class FullName < Base
          object_of :full_name, String
        end

        object_of :name, FullName
        object_of :address, BaseAddress
      end

      object_of :name, SubscriberName
      object_of :email_address, String
      object_of :shipping_address, ShippingAddress
    end

    # https://developer.paypal.com/docs/api/subscriptions/v1/#definition-application_context
    class ApplicationContext < Base
      class PaymentMethod < Base
        object_of :payer_selected, String
        object_of :payee_preferred, String
      end

      object_of :id, String
      object_of :brand_name, String
      object_of :locale, String
      object_of :shipping_preference, String # GET_FROM_FILE(default)|NO_SHIPPING|SET_PROVIDED_ADDRESS
      object_of :user_action, String
      object_of :payment_method, PaymentMethod
      object_of :return_url, String
      object_of :cancel_url, String
    end

    object_of :plan_id, String
    object_of :id, String
    object_of :start_time, DateTime # default: Time.now
    object_of :status, String
    object_of :status_update_time, DateTime
    object_of :quantity, Integer
    object_of :shipping_amount, Money
    object_of :subscriber, Subscriber
    object_of :auto_renewal, Boolean
    object_of :application_context, ApplicationContext
    object_of :create_time, DateTime
    array_of  :links, Link
  end
end
