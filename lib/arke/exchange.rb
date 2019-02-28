require 'exchange/bitfinex'
require 'exchange/rubykube'

module Arke
  # Exchange module, contains Exchanges drivers implementation
  module Exchange
    # Fabric method, creates proper Exchange instance
    # * takes +strategy+ (+Arke::Strategy+) and passes to Exchange initializer
    # * takes +config+ (hash) and passes to Exchange initializer
    # * takes +config+ and resolves correct Exchange class with +exchange_class+ helper
    def self.create(config)
      exchange_class(config['driver']).new(config)
    end

    def self.create_ws(config, pair)
      exchange_class(config['driver']).new(pair)
    end

    # Takes +dirver+ - +String+
    # Resolves correct Exchange class by it's name
    def self.exchange_class(driver)
      Arke::Exchange.const_get(driver.capitalize)
    end
  end
end
