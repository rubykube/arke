# encoding: UTF-8
# frozen_string_literal: true

require 'rbtree'
require_relative 'price_level'

module Arke
  class Orderbook

    def initialize(market)
      @market = market
      @orders = {}
      @book = {
        ask: ::RBTree.new,
        bid: ::RBTree.new
      }
    end

    def add(order)
      @orders[order.id] = order

      side = @book[order.side]
      side[order.price] ||= PriceLevel.new(order.price)
      side[order.price].add order
    end

    def remove(id)
      order = @orders[id]
      @book[order.side][order.price].remove(order)
      @orders.delete(id)
    end

    def find(id)
      return @orders[id]
    end

    def dump
      @book
    end

  end
end
