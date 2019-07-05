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
end
