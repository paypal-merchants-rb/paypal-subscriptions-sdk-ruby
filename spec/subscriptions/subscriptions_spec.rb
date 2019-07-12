require 'date'

RSpec.describe PayPal::SDK::Subscriptions::Subscription do
  let(:product) { PayPal::SDK::Subscriptions::Product.all(page_size: 1).products.first || raise('no products!') }

  let(:plan_attributes) do
    # https://developer.paypal.com/docs/api/subscriptions/v1/#plans_get
    {
      "product_id" => product.id,
      "name" => "Basic Plan",
      "description" => "Basic plan",
      "billing_cycles" => [
        {
          "frequency" => { "interval_unit" => "MONTH", "interval_count" => 1 },
          "tenure_type" => "TRIAL",
          "sequence" => 1,
          "total_cycles" => 1
        },
        {
          "frequency" => { "interval_unit" => "MONTH", "interval_count" => 1 },
          "tenure_type" => "REGULAR",
          "sequence" => 2,
          "total_cycles" => 12,
          "pricing_scheme" => {
            "fixed_price" => { "value" => "10", "currency_code" => "USD" }
          }
        }
      ],
      "payment_preferences" => {
        "service_type" => "PREPAID",
        "auto_bill_outstanding" => true,
        "setup_fee" => { "value" => "10", "currency_code" => "USD" },
        "setup_fee_failure_action" => "CONTINUE",
        "payment_failure_threshold" => 3
      },
      "quantity_supported" => true,
      "taxes" => { "percentage" => "10", "inclusive" => false }
    }
  end
  let(:plan) { PayPal::SDK::Subscriptions::Plan.create!(plan_attributes) }

  let(:subscription_attributes) do
  {
    "plan_id" => plan.id,
    "start_time" => (Date.today + 1),
    "quantity" => "20",
    "shipping_amount" => {
      "currency_code" => "USD",
      "value" => "10.00"
    },
    "subscriber" => {
      "name" => {
        "given_name" => "John",
        "surname" => "Doe"
      },
      "email_address" => "customer@example.com",
      "shipping_address" => {
        "name" => {
          "full_name" => "John Doe"
        },
        "address" => {
          "address_line_1" => "2211 N First Street",
          "address_line_2" => "Building 17",
          "admin_area_2" => "San Jose",
          "admin_area_1" => "CA",
          "postal_code" => "95131",
          "country_code" => "US"
        }
      }
    },
    "auto_renewal" => true,
    "application_context" => {
      "brand_name" => "example",
      "locale" => "en-US",
      "shipping_preference" => "SET_PROVIDED_ADDRESS",
      "user_action" => "SUBSCRIBE_NOW",
      "payment_method" => {
        "payer_selected" => "PAYPAL",
        "payee_preferred" => "IMMEDIATE_PAYMENT_REQUIRED"
      },
      "return_url" => "https://example.com/returnUrl",
      "cancel_url" => "https://example.com/cancelUrl"
    }
  }
  end

  it "creates a subscription" do
    subscription = described_class.create!(subscription_attributes)

    expect(subscription.id).to match(/\AI-/)
    expect(subscription.status).to eq 'APPROVAL_PENDING'

    # https://developer.paypal.com/docs/api/subscriptions/v1/#subscriptions_patch example invalid
    # new_balance = { currency_code: 'USD', value: '10.99' }
    # subscription.update!(op: :replace, path: '/billing_info/outstanding_balance', value: new_balance)

    # Can't test without approval
    expect { subscription.activate! }.to raise_error(PayPal::SDK::Core::Exceptions::ResourceInvalid)
    # expect(subscription.status).to eq 'ACTIVE'

    expect do
      subscription.capture!('Charging as the balance reached the limit', value: '10.99', currency_code: 'USD')
    end.to raise_error(PayPal::SDK::Core::Exceptions::ResourceNotFound)

    expect do
      subscription.suspend!('Item out of stock')
    end.to raise_error(PayPal::SDK::Core::Exceptions::ResourceNotFound)

    expect { subscription.cancel! }.to raise_error(PayPal::SDK::Core::Exceptions::ResourceNotFound)
    # expect(subscription.status).to eq 'CANCELED'
  end
end
