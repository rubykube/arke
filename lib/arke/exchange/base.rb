module Arke::Exchange
  class Base
    def initialize(config, strategy)
      @strategy = strategy
    end

    def call(action)
    end
  end
end
