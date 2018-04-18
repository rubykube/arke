# frozen_string_literal: true

module Broker
  # Responsible for acting as Facade to Broker Adapter
  module Router
    def order_books
      jobs =
        Broker::Settings.enabled.map do |name|
          Broker::Adapter.adaptee = name
          Concurrent::Promises.future { Broker::Adapter.order_book }
        end

      Concurrent::Promises.zip(*jobs).value!.flatten
    end
    module_function :order_books
  end
end
