# frozen_string_literal: true

module Broker
  # Responsible for acting as Facade to Broker Adapter
  module Router
    def order_books
      jobs =
        Broker::Settings::General.enabled.map do |name|
          Concurrent::Promises.future do
            require 'broker/adapter' unless defined?(Broker::Adapter)
            Broker::Adapter.adaptee = name
            Broker::Adapter.order_book
          end
        end

      Concurrent::Promises.zip(*jobs).value!(5).flatten
    end
    module_function :order_books
  end
end
