module Arke
  class Orderbook

    attr_reader :book

    def initialize(market)
      @market = market
      @book = {
        sell: [],
        buy: []
      }
    end

    def add(order)
      @book[order.side].push(order) unless contains?(order)
    end

    def remove(order)
      index = @book[order.side].index { |b| b.id == order.id }
      @book[order.side].delete_at(index) unless index.nil?
    end

    def update(order)
      index = @book[order.side].index { |b| b.id == order.id }
      @book[order.side][index] = order unless index.nil?
    end

    def contains?(order)
      @book[order.side].find { |b| b.id == order.id } ? true : false
    end

    # get with the lowest price
    def get(side)
      @book[side].min { |a, b| a.price <=> b.price }
    end

  end
end
