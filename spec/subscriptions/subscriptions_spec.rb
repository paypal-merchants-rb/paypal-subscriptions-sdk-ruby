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

  it "creates a product" do
    product = PayPal::SDK::Subscriptions::Product.new(ProductAttributes)

    expect(product.create).to be_truthy
  end
end
