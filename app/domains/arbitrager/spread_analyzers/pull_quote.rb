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
        [
          sort(quotes, Broker::Settings::General.bid_side.singularize).last,
          sort(quotes, Broker::Settings::General.ask_side.singularize).first
        ]
      end

      def worst_quote(quotes)
        [
          sort(quotes, Broker::Settings::General.bid_side.singularize).first,
          sort(quotes, Broker::Settings::General.ask_side.singularize).last
        ]
      end

      def sort(quotes, side)
        quotes
          .select { |q| q[:side] == side }
          .sort_by { |q| q[:price] }
      end
    end
  end
end
