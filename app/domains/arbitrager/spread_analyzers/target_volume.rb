# frozen_string_literal: true

require 'dry/transaction/operation'

module Arbitrager
  module SpreadAnalyzers
    # Responsible for calculating available volume
    class TargetVolume
      include Dry::Transaction::Operation

      def call(available_volume)
        [available_volume, Broker::Settings::General.max_order_amount].min
      end
    end
  end
end
