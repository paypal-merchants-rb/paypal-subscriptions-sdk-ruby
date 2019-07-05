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
end
