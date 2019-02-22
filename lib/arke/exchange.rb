require 'exchange/base'
require 'exchange/bitfinex'
require 'exchange/rubykube'

module Arke
  module Exchange
    def self.create(config, strategy)
      exchange_class(config['driver']).new(config, strategy)
    end

    def self.exchange_class(driver)
      Arke::Exchange.const_get(driver.capitalize)
    end
  end
end
