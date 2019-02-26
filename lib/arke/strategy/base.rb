require 'exchange'
require 'action'

module Arke::Strategy
  # Base class for all strategies
  class Base
    def initialize(config)
      @sources = []
      @target = nil
      @order_queue = Queue.new
    end

    # Should be overriden
    def call; end

    # Add +Arke::Workers+ to allow strategy to send +Arke::Actions+ them
    def add_source_worker(worker)
      @sources.push(worker)
    end

    # Sets target worker for strategy,
    # strategy sends Arke::Actions to target worker
    def set_target_worker(worker)
      @target = worker
    end
  end
end
