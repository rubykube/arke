# frozen_string_literal: true

module Broker
  module Settings
    # Settings related to Broker domain
    class General
      extend Dry::Configurable

      with_options reader: true do
        setting :default, :bitfinex
        setting :enabled, %i[bitfinex cex kraken]
        setting :ask_side, 'asks'
        setting :bid_side, 'bids'
      end
    end
  end
end
