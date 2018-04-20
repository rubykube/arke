# frozen_string_literal: true

module Broker
  # Settings related to Broker domain
  class Settings
    extend Dry::Configurable

    setting :default, 'bitfinex', reader: true
    setting :enabled, %i[bitfinex cex craken], reader: true
    setting :quote_aggregation_interval, 3, reader: true
  end
end
