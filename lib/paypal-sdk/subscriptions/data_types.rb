module PayPal::SDK::Subscriptions

  class Base < PayPal::SDK::Core::API::DataTypes::Base
    class Number < Float
    end
  end

  class Money < Base
    object_of :currency_code, String
    object_of :value, String
  end

  class Patch < Base
    object_of :op, String
    object_of :path, String
    object_of :value, Object
    object_of :from, String
  end
end
