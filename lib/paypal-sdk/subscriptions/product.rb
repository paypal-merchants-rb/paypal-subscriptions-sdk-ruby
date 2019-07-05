module PayPal::SDK::Subscriptions
  class Product < Base
    object_of :id, String # 6-50 chars. Default: system generated, prefixed with PROD-
    object_of :name, String
    object_of :description, String
    object_of :type, String # PHYSICAL|DIGITAL|SERVICE
    object_of :category, String
    object_of :image_url, String
    object_of :home_url, String
    object_of :create_time, String
    object_of :update_time, String
    array_of  :links, Links

    include RequestDataType

    def create
      path = "v1/catalogs/products"
      response = api.post(path, self.to_hash, http_header)
      self.merge!(response)
      success?
    end
  end

  # https://developer.paypal.com/docs/api/catalog-products/v1/
  class Products < Base
    object_of :total_items, Integer
    object_of :total_pages, Integer
    array_of :products, Product
    array_of :links, Links # self, next, last

    include RequestDataType

    # optional params include 'page', 'page_size', and 'total_required'
    def self.list(params = {})
      path = "v1/catalogs/products"
      response = api.get(path, params)
      new(response)
    end

    def next
      link = links.detect { |l| l.rel == 'next' }
      if link
        uri = URI.parse(link.href)
        response = api.api_call(method: :get, uri: uri, header: {})
        self.class.new(response)
      end
    end
  end
end
