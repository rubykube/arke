# frozen_string_literal: true

module Broker
  module Settings
    # Settings related to Broker domain
    class QuoteAggregation
      extend Dry::Configurable

      with_options reader: true do
        setting :interval, 3
        setting :ask_side, 'asks'
        setting :bid_side, 'bids'
      end
    end
  end
end
