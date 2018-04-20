# frozen_string_literal: true

module Broker
  # Responsible for fetching order books every `execution_interval`seconds
  # and notifying Arbitrager::QuoteAggregatorObserver
  module QuoteAggregator
    def order_books
      task = Concurrent::TimerTask.new { Broker::Router.order_books }
      task.execution_interval = 180
      task.timeout_interval = 15
      task.add_observer(Arbitrager::QuoteAggregatorObserver.new, :update)
      task.execute
    end
    module_function :order_books
  end
end
