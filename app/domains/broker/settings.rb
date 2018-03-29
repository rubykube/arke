# frozen_string_literal: true

module Broker
  # Settings related to Broker domain
  class Settings
    extend Dry::Configurable

    setting :default_adaptee, 'bitfinex', reader: true
  end
end
