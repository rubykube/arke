# frozen_string_literal: true

module Broker
  module Settings
    # Settings related to Broker domain
    class Kraken
      extend Dry::Configurable

      with_options reader: true do
        setting :pair, 'xbtusd'
        setting :api do
          setting :version, '0'
          setting :uri, 'https://api.kraken.com/'
        end
        setting :order_book do
          setting :uri, 'public/Depth'
          setting :depth, 10
        end
      end
    end
  end
end
