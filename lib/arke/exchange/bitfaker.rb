require 'orderbook'

module Arke::Exchange
  class Bitfaker

    attr_reader :orderbook

    def initialize(opts)
      @market = opts['market']
      @orderbook = Arke::Orderbook.new(@market)
    end

    def start
      load_orderbook
    end

    def print
      puts "Exchange #{@driver} market: #{@market}"
      puts @orderbook.print(:buy)
      puts @orderbook.print(:sell)
    end

    def create_order(order)
      pp order
    end

    def stop_order(order)
      pp order
    end

    private

    def load_orderbook
      fixture = YAML.load_file('spec/support/fixtures/bitfinex.yaml')
      orders = fixture[1]
      orders.each { |order| add_order(order) }
    end

    def add_order(order)
      id, price, amount = order
      side = (amount.negative?) ? :sell : :buy
      amount = amount.abs
      @orderbook.create(Arke::Order.new(id, @market, price, amount, side))
    end
  end
end
