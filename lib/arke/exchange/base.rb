module Arke::Exchange
  class Base
    RunNotOverriden = Class.new(StandardError)

    def initialize(strategy)
      @strategy = strategy
    end

    def start
      on_start

      until @strategy.shutdown?
        run
      end

      on_stop
    end

    # methods to override
    def run
      raise RunNotOverriden.new
    end

    def on_start
    end

    def on_stop
    end
  end
end
