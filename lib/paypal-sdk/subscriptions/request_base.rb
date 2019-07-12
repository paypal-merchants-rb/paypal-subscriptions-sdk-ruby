require 'securerandom'

module PayPal::SDK::Core::Exceptions
  # 422 Unprocessable Entity
  class ResourceInvalid < ClientError # :nodoc:
  end
end

module PayPal::SDK::Subscriptions
  include PayPal::SDK::Core::Exceptions

  # API error: returned as 200 + "error" key in response.
  class UnsuccessfulApiCall < RuntimeError
    attr_reader :api_error

    def initialize(api_error)
      super(api_error['message'])
      @api_error = api_error
    end
  end

  class RequestAPIBase < PayPal::SDK::Core::API::DataTypes::Base
    include RequestDataType

    attr_accessor :error
    attr_writer   :header, :request_id

    def header
      @header ||= {}
    end

    def request_id
      @request_id ||= SecureRandom.uuid
    end

    def http_header
      { "PayPal-Request-Id" => request_id.to_s }.merge(header)
    end

    def success?
      @error.nil?
    end

    def merge!(values)
      @error = nil
      super
    end

    def raise_error!
      raise UnsuccessfulApiCall, error if error
    end

    def self.raise_on_api_error(*methods)
      methods.each do |symbol|
        define_method("#{symbol}!") {|*arg|
          raise_error! unless send(symbol, *arg)
        }
      end
    end
  end

  class Patch < Base
    object_of :op, String
    object_of :path, String
    object_of :value, Object
    object_of :from, String
  end

  class RequestBase < RequestAPIBase
    def path(id = nil)
      self.class.path(id)
    end

    def commit(path, data = {}, method = :post)
      merge! api.send(method, path, data, http_header)
      success?
    end

    def create
      commit(path, to_hash)
    end
    raise_on_api_error :create

    def self.find(resource_id)
      raise ArgumentError.new("id required") if resource_id.to_s.strip.empty?
      new api.get(path resource_id)
    end

    # patch [Hash] { op: 'replace', path: , value: }
    def update(patch)
      patch = Patch.new(patch) unless patch.is_a? Patch
      commit(path(id), [patch.to_hash], :patch)
    end
    raise_on_api_error :update
  end
end
