# frozen_string_literal: true

module Broker
  module Settings
    # Settings related to cex.io broker
    class Cex
      extend Dry::Configurable

      with_options reader: true do
        setting :pair, 'BTC/USD'
        setting :uri, 'https://cex.io/api'
        setting :order_book do
          setting :uri, 'order_book'
          setting :depth, 3
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
