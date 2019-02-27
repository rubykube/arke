require 'rbtree'

module Arke
  class Orderbook

    attr_reader :book

    def initialize(market)
      @market = market
      @book = {
        sell: ::RBTree.new,
        buy: ::RBTree.new
      }
    end

    def add_order(order)
      add(order) unless contains?(order)
    end

    def remove_order(order)
      remove(order) if order && contains?(order)
    end

    def contains?(order)
      return false if @book[order.side][order.price].nil?
      @book[order.side][order.price].find{ |o| o.id == order.id } ? true : false
    end

    # get with the lowest price
    def get(side)
      @book[side].first.last
    end

    private

    def add(order)
      @book[order.side][order.price] ||= []
      @book[order.side][order.price].push order
    end

    def remove(order)
      @book[order.side][order.price].delete order
      @book[order.side].delete(order.price) if @book[order.side][order.price].empty?
    end

  end
end
