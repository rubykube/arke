# frozen_string_literal: true

module Broker
  # Settings related to Broker domain
  class Settings
    extend Dry::Configurable

    with_options reader: true do |o|
      o.setting :default, 'bitfinex'
      o.setting :enabled, %i[bitfinex cex craken]
      o.setting :quote_aggregation, reader: true do
        setting :interval, 3
        setting :ask_side, 'asks'
        setting :bid_side, 'bids'
      end
    end
  end
end
