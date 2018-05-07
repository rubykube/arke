# frozen_string_literal: true

module Broker
  # Responsible for converting adaptee interface
  # into target interface required by client
  module Adapter
    def order_book
      adaptee.order_book
    end

    def adaptee
      return @adaptee if @adaptee.present?
      self.adaptee = Broker::Settings.default
    end

    def adaptee=(adaptee)
      require "broker/adaptee/#{adaptee}"
      @adaptee = Broker::Adaptee.const_get(adaptee.to_s.capitalize)
    end

    module_function :order_book,
                    :adaptee,
                    :'adaptee='
  end
end
