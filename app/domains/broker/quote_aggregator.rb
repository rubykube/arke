# frozen_string_literal: true

module Broker
  # Responsible for fetching order books every `execution_interval`seconds
  # and notifying Arbitrager::QuoteAggregatorObserver
  module QuoteAggregator
    def order_books
      task =
        Concurrent::TimerTask.new do
          Broker::Router.order_books
        end
      task.execution_interval = Broker::Settings::QuoteAggregation.interval
      task.timeout_interval = Broker::Settings::QuoteAggregation.timeout
      task.add_observer(Arbitrager::QuoteAggregatorObserver.new, :update)
      task.execute
    end
    module_function :order_books
  end
end
