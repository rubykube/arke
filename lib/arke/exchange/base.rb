# frozen_string_literal: true

module Arke::Exchange
  class Base
    attr_accessor :action_queue

    class RunNotOverriden < StandardError; end
    class UnknownActionError < StandardError; end

    ACTIONS = %i[create update cancel].freeze

    def initialize(strategy)
      @strategy = strategy
      @action_queue = Queue.new
    end

    def start
      on_start

      run until @strategy.shutdown?

      on_stop
    rescue StandardError => e
      Arke::Log.fatal e
      exit
    end

    # methods to override
    def run
      Thread.new do
        yield
      end
    end

    def add_action(type, data)
      raise UnknownActionError unless ACTIONS.include? type
      @action_queue << { type: data }
    end

    def on_start; end

    def on_stop; end
  end
end
