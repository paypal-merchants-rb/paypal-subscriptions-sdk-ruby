require 'date'

RSpec.describe PayPal::SDK::Subscriptions do
  it "has a version number" do
    expect(PayPal::SDK::Subscriptions::VERSION).not_to be nil
  end

  ProductAttributes = {
    "name" => "Video Streaming Service",
    "description" => "Video streaming service",
    "type" => "SERVICE",
    "category" => "SOFTWARE",
    "image_url" => "https://example.com/streaming.jpg",
    "home_url" => "https://example.com/home"
  }

  PlanAttributes = {
    "product_id" => "PROD-XXCD1234QWER65782",
    "name" => "Basic Plan",
    "description" => "Basic plan",
    "billing_cycles" => [
      {
        "frequency" => {
          "interval_unit" => "MONTH",
          "interval_count" => 1
        },
        "tenure_type" => "TRIAL",
        "sequence" => 1,
        "total_cycles" => 1
      },
      {
        "frequency" => {
          "interval_unit" => "MONTH",
          "interval_count" => 1
        },
        "tenure_type" => "REGULAR",
        "sequence" => 2,
        "total_cycles" => 12,
        "pricing_scheme" => {
          "fixed_price" => {
            "value" => "10",
            "currency_code" => "USD"
          }
        }
      }
    ],
    "payment_preferences" => {
      "service_type" => "PREPAID",
      "auto_bill_outstanding" => true,
      "setup_fee" => {
        "value" => "10",
        "currency_code" => "USD"
      },
      "setup_fee_failure_action" => "CONTINUE",
      "payment_failure_threshold" => 3
    },
    "quantity_supported" => true,
    "taxes" => {
      "percentage" => "10",
      "inclusive" => false
    }
  }

  SubscriptionAttributes = {
    "plan_id" => "P-4ML8771254154362WXNWU5BC",
    "start_time" => (Date.today + 1).strftime('%FT%TZ'), # eg. "2018-11-01T00:00:00Z",
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

  it "creates a product" do
    product = PayPal::SDK::Subscriptions::Product.new(ProductAttributes)

    expect(product.create).to be_truthy
  end

  it "lists products" do
    page = PayPal::SDK::Subscriptions::Products.list('page_size' => 99, 'total_required' => true)

    expect(page.products.size).to be >= 0
    expect(page.total_items).to be >= 0
    expect(page.total_pages).to be >= 0
  end

  it "paginates" do
    page = PayPal::SDK::Subscriptions::Products.list('page_size' => 1, 'total_required' => true)
    page = page.next

    expect(page.products.size).to be >= 0
  end

  it "creates a product, plan and subscription" do
    product = PayPal::SDK::Subscriptions::Product.new(ProductAttributes)
    expect(product.create).to be true

    plan = PayPal::SDK::Subscriptions::BillingPlan.new(PlanAttributes)
    plan.product_id = product.id
    expect(plan.create).to be true

    subscription = PayPal::SDK::Subscriptions::Subscription.new(SubscriptionAttributes)
    subscription.plan_id = plan.id
    expect(subscription.create).to be true
    expect(subscription.id).to match(/\AI-/)
  end
end
