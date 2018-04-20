# frozen_string_literal: true

module Broker
  # Responsible for fetching order books every `execution_interval`seconds
  # and notifying Arbitrager::QuoteAggregatorObserver
  module QuoteAggregator
    def order_books
      task = Concurrent::TimerTask.new { Broker::Router.order_books }
      task.execution_interval = Broker::Settings.quote_aggregation_interval
      task.timeout_interval = Broker::Settings.quote_aggregation_interval * 5
      task.add_observer(Arbitrager::QuoteAggregatorObserver.new, :update)
      task.execute
    end
    module_function :order_books
  end
end
