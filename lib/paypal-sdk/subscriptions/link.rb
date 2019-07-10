module PayPal::SDK::Subscriptions
  # https://developer.paypal.com/docs/api/reference/api-responses/#hateoas-links
  # https://developer.paypal.com/docs/api/subscriptions/v1/#definition-link_description
  class Link < Base
    object_of :href, String
    object_of :rel, String
    object_of :method, String

    def call
      response = api.api_call(method: link.method, uri: URI.parse(link.href), header: {})
      response
    end
  end
end
