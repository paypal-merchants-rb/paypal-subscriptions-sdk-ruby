RSpec.describe PayPal::SDK::Subscriptions::Product do

  ProductAttributes = {
    "name" => "Video Streaming Service",
    "description" => "Video streaming service",
    "type" => "SERVICE",
    "category" => "SOFTWARE",
    "image_url" => "https://example.com/streaming.jpg",
    "home_url" => "https://example.com/home"
  }

  it "creates a product" do
    product = described_class.new(ProductAttributes)

    expect(product.create).to be true
    expect(product.id).to match(/\APROD-/)
  end

  it "errors if product invalid" do
    product = described_class.new

    expect { product.create! }.to raise_error(PayPal::SDK::Subscriptions::UnsuccessfulApiCall)
  end

  it "lists products" do
    page = described_class.all('page_size' => 99, 'total_required' => true)

    expect(page.products.size).to be >= 0
    expect(page.total_items).to be >= 0
    expect(page.total_pages).to be >= 0
  end

  it "paginates" do
    page = described_class.all('page_size' => 1, 'total_required' => true)
    page = page.next

    expect(page.products.size).to be >= 0
  end
end
