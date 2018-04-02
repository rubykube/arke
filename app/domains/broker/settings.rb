# frozen_string_literal: true

module Broker
  # Settings related to Broker domain
  class Settings
    extend Dry::Configurable

    setting :default, 'bitfinex', reader: true
    setting :enabled, %i[bitfinex cex craken], reader: true
  end
end
