# frozen_string_literal: true

module Broker
  module Settings
    # Settings related to Broker domain
    class Bitfinex
      extend Dry::Configurable

      with_options reader: true do
        setting :version, 'v1'
        setting :uri, 'https://api.bitfinex.com'
        setting :pair, 'btcusd'
        setting :order_book do
          setting :uri, 'book'
          setting :depth, 3
          setting :group, 1
        end
      end
    end
  end
end
