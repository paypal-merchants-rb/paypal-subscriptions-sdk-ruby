RSpec.describe PayPal::SDK::Subscriptions::Plan do

  let(:product) { PayPal::SDK::Subscriptions::Product.all.products.first } # assumes product exists, Product class functional.

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

  it "creates a plan" do
    plan = described_class.new(plan_attributes)

    expect(plan.create).to be true
    expect(plan.id).to match(/\AP-/)
  end
end
