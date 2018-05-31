# frozen_string_literal: true

require 'dry/transaction/operation'

module Arbitrager
  module SpreadAnalyzers
    # Responsible for calculating total commission of bid/asd pair
    class TotalCommission
      include Dry::Transaction::Operation

      def call(quotes, target_volume)
        quotes.reduce(BigDecimal('0')) do |sum, quote|
          settings = Broker::Settings.const_get(quote[:broker].to_s.capitalize)
          total_commission_persent =
            settings.fees.margin.opening + settings.fees.transaction.taker

          sum + quote[:price] * target_volume * total_commission_persent / 100
        end
      end
    end
  end
end
