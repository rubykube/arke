# frozen_string_literal: true

require 'dry/transaction/operation'

module Arbitrager
  module SpreadAnalyzers
    # Responsible for calculating best/wors ask/bid from quotes
    class GetSpread
      include Dry::Transaction::Operation

      def call(bid, ask)
        bid - ask
      end

      def inverted?(bid, ask)
        call(bid, ask) < 0
      end
    end
  end
end
