# frozen_string_literal: true

module Arbitrager
  # Responsible for receiving aggrigated order books from BrokerQuoteAggregator
  class QuoteAggregatorObserver
    def update(time, result, exception)
      if result
        print "(#{time}) Execution successfully returned #{result}\n"
      elsif exception.is_a?(Concurrent::TimeoutError)
        print "(#{time}) Execution timed out\n"
      else
        print "(#{time}) Execution failed with error #{exception}\n"
      end
    end
  end
end
