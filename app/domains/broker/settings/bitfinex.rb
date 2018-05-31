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
        setting :fees do
          setting :margin do
            setting :opening, 0.01
            setting :rollover, 0.01
            setting :rollover_period, 4
          end
          setting :transaction do
            setting :maker, 0.16
            setting :taker, 0.26
          end
        end

      end
    end
  end
end
