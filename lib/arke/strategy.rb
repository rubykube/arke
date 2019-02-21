require 'strategy/base'
require 'strategy/copy'

module Arke
  module Strategy
    def self.create(type)
      strategy_class(type).new
    end

    def self.strategy_class(type)
      Arke::Strategy.const_get(type.capitalize)
    end
  end
end
