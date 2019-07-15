module PayPal::SDK::Subscriptions

  class Base < PayPal::SDK::Core::API::DataTypes::Base
    class Number < Float
    end
  end

  class EnumType < PayPal::SDK::Core::API::DataTypes::Enum
  end

  class Money < Base
    object_of :currency_code, String
    object_of :value, String
  end
end
