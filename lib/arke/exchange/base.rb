module Arke::Exchange
  # This is a base class for all Exchanges
  class Base
    # Takes strategy, config
    # * sets @startegy reference
    def initialize(config, strategy)
      @strategy = strategy
    end

    # Should be overriden
    def call(action)
    end
  end
end
