# frozen_string_literal: true

module Arbitrager
  # Responsible for receiving aggrigated order books from BrokerQuoteAggregator
  class QuoteAggregatorObserver
    def update(time, result, exception)
      if result
        print "(#{time}) Execution successfully returned #{pp result}\n"
        bid, ask = Arbitrager::SpreadAnalyzers::PullQuote.new.call(result, :best)
        print "Best bid: #{bid[:broker].to_s.capitalize}, price: #{bid[:price]}\n"
        print "Best ask: #{ask[:broker].to_s.capitalize}, price: #{ask[:price]}\n"
        print "Spread: #{ Arbitrager::SpreadAnalyzers::GetSpread.new.call(bid[:price], ask[:price])}\n"
        print "Available Volume: #{ available_volume = Arbitrager::SpreadAnalyzers::AvailableVolume.new.call(bid, ask)}\n"
        print "Target Volume: #{ Arbitrager::SpreadAnalyzers::TargetVolume.new.call(available_volume)}\n"
      elsif exception.is_a?(Concurrent::TimeoutError)
        print "(#{time}) Execution timed out\n"
      else
        print "(#{time}) Execution failed with error #{exception}\n"
      end
    end
  end
end
