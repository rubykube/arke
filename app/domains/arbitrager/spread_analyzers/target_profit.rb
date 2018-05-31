# frozen_string_literal: true

require 'dry/transaction/operation'

module Arbitrager
  module SpreadAnalyzers
    # Responsible for calculating expected profit
    class TargetProfit
      include Dry::Transaction::Operation

      def call(spread, target_volume, commission)
        spread * target_volume - commission
      end
    end
  end
end
