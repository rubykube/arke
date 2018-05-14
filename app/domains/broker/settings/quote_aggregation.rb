# frozen_string_literal: true

module Broker
  module Settings
    # Settings related to Broker domain
    class QuoteAggregation
      extend Dry::Configurable

      with_options reader: true do
        setting :interval, 3
        setting :timeout, 6
      end
    end
  end
end
