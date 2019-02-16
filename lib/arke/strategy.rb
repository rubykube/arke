require 'arke/strategy/copy'

module Arke
  module Strategy
    def self.create(config)
      strategy_class(config['type']).new
    end

    def self.strategy_class(type)
      Arke::Strategy.const_get(type.capitalize)
    end
  end
end
