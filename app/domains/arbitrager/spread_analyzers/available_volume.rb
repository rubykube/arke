# frozen_string_literal: true

require 'dry/transaction/operation'

module Arbitrager
  module SpreadAnalyzers
    # Responsible for calculating best/wors ask/bid from quotes
    class AvailableVolume
      include Dry::Transaction::Operation

      def call(bid, ask)
        [bid, ask]
      end
    end
  end
end
