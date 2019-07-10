module PayPal::SDK::Subscriptions
  # https://developer.paypal.com/docs/api/catalog-products/v1/
  class Product < RequestBase
    object_of :id, String # 6-50 chars. Default: system generated, prefixed with PROD-
    object_of :name, String
    object_of :description, String
    object_of :type, String # PHYSICAL|DIGITAL|SERVICE
    object_of :category, String
    object_of :image_url, String
    object_of :home_url, String
    object_of :create_time, String
    object_of :update_time, String
    array_of  :links, Link

    # patch [Hash] { op: 'replace', path: , value: }
    # path = [/description|/category|/image_url|/home_url]
    def update(patch)
      super
    end

    class Page < RequestBase
      object_of :total_items, Integer
      object_of :total_pages, Integer
      array_of :products, Product
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
        "v1/catalogs/products/#{resource_id}"
      end

      # options include 'page', 'page_size', and 'total_required'
      def all(options = {})
        Page.new(api.get(path, options))
      end
    end
  end
end
