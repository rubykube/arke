require 'exchange/bitfinex'
require 'exchange/rubykube'

module Arke
  module Exchange
    def self.exchange_class(type)
      Arke::Exchange.const_get(type.capitalize)
    end
  end
end
