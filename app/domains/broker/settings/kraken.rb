# frozen_string_literal: true

module Broker
  module Settings
    # Settings related to Broker domain
    class Kraken
      extend Dry::Configurable

      with_options reader: true do
        setting :version, '0'
        setting :uri, 'https://api.kraken.com'
        setting :pair, 'xbtusd'
        setting :order_book do
          setting :uri, 'public/Depth'
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
