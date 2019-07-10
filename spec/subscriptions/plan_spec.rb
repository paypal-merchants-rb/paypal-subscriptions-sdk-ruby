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

  it "creates, updates and finds a plan" do
    plan = described_class.new(plan_attributes)

    expect(plan.create).to be true
    expect(plan.id).to match(/\AP-/)
    expect(plan.status).to eq 'ACTIVE'

    plan.update!(op: :replace, path: '/description', value: 'Updated plan')
    plan.deactivate!

    found = described_class.find(plan.id)

    expect(found.description).to eq 'Updated plan'
    expect(found.status).to eq 'INACTIVE'

    found.activate!
    found.reload

    expect(found.status).to eq 'ACTIVE'
  end

  it "lists plans" do
    page = described_class.all('page_size' => 1)

    expect(page.plans.size).to eq 1
  end

  it "paginates" do
    page = described_class.all('page_size' => 1)
    page = page.next

    expect(page.plans.size).to eq 1
  end
end
