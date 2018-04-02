# frozen_string_literal: true

module Broker
  module Adaptee
    module ResponseNormalizers
      # Responsible for normalizing response from API
      module Bitfinex
        def order_book(response)
          response
        end
        module_function :order_book
      end
    end
  end
end


# Unable to autoload constant Broker::Adaptee::ResponseNormalizers::Bitfinex,
# expected /Users/dvanidovskiy/www/arke/app/domains/broker/adaptee/response_normalizers/bitfinex.rb to define it (LoadError)
