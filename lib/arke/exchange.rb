require 'exchange/base'
require 'exchange/bitfinex'
require 'exchange/rubykube'

module Arke
  module Exchange
    def self.create(type, strategy)
      exchange_class(type).new(strategy)
    end

    def self.exchange_class(type)
      Arke::Exchange.const_get(type.capitalize)
    end
  end
end
