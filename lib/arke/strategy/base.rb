require 'exchange'
require 'action'

module Arke::Strategy
  # Base class for all strategies
  class Base
    attr_reader :pair

    def initialize(config)
      @sources = []
      @target = nil
      @pair = config['pair']
      @order_queue = Queue.new
    end

    def push(action)
      action
    end
  end
end
