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
          setting :depth, 10
        end
      end
    end
  end
end
