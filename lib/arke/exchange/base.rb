module Arke::Exchange
  class Base
    RunNotOverriden = Class.new(StandardError)

    def initialize(strategy)
      @strategy = strategy
    end

    def call(action)
    end
  end
end
