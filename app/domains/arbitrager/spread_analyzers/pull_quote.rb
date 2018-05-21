# frozen_string_literal: true

require 'dry/transaction/operation'

module Arbitrager
  module SpreadAnalyzers
    # Responsible for calculating best/wors ask/bid from quotes
    class PullQuote
      include Dry::Transaction::Operation

      def call(quotes, pull_case = :best)
        raise ArgumentError unless %i[best worst].include?(pull_case)

        return best_quote(quotes) if pull_case.to_sym == :best

        worst_quote(quotes) if pull_case.to_sym == :worst
      end

      private

      def best_quote(quotes)
        [highest_bid(quotes), lowest_ask(quotes)]
      end

      def worst_quote(quotes)
        [lowest_bid(quotes), highest_ask(quotes)]
      end

      def sort(quotes, side)
        quotes
          .select { |q| q[:side] == side }
          .sort_by { |q| q[:price] }
      end

      def sorted_bid_glass(quotes)
        sort(quotes, Broker::Settings::General.bid_side.singularize)
      end

      def sorted_ask_glass(quotes)
        sort(quotes, Broker::Settings::General.ask_side.singularize)
      end

      def highest_bid(quotes)
        sorted_bid_glass(quotes).last
      end

      def lowest_ask(quotes)
        sorted_ask_glass(quotes).first
      end

      def lowest_bid(quotes)
        sorted_bid_glass(quotes).first
      end

      def highest_ask(quotes)
        sorted_ask_glass(quotes).last
      end
    end
  end
end
