# frozen_string_literal: true

module Broker
  module Settings
    # Settings related to Broker domain
    class General
      extend Dry::Configurable

      with_options reader: true do
        setting :enabled, %i[bitfinex cex kraken]
        setting :default, :bitfinex
        setting :ask_side, 'asks'
        setting :bid_side, 'bids'
        setting :max_exposure, 10_000
        setting :min_exposure, 25
        setting :min_order_amount, 0.01
        setting :max_order_amount, 0.01
      end
    end
  end
end
