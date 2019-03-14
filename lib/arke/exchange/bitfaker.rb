require 'exchange/base'
require 'orderbook'

module Arke::Exchange
  class Bitfaker < Base

    attr_reader :orderbook

    def initialize(opts)
      super

      @orderbook = Arke::Orderbook.new(@market)
    end

    def start
      load_orderbook
    end

    def create_order(order)
      pp order
    end

    def stop_order(order)
      pp order
    end

    def ping; end

    private

    def load_orderbook
      fixture = YAML.load_file('spec/support/fixtures/bitfinex.yaml')
      orders = fixture[1]
      orders.each { |order| add_order(order) }
    end

    def add_order(order)
      _id, price, amount = order
      side = (amount.negative?) ? :sell : :buy
      amount = amount.abs
      @orderbook.update(Arke::Order.new(@market, price, amount, side))
    end
  end
end
