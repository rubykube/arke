require 'rbtree'
require 'tty-table'
require 'order'

module Arke
  class Orderbook

    attr_reader :book

    def initialize(market)
      @market = market
      @book = {
        index: ::RBTree.new,
        buy: ::RBTree.new,
        sell: ::RBTree.new
      }
    end

    def update(order)
      @book[order.side][order.price] = order.amount
    end

    def delete(order)
      @book[order.side].delete(order.price)
    end

    def contains?(order)
      !@book[order.side][order.price].nil?
    end

    # get with the lowest price
    def get(side)
      @book[side].first
    end

    def print(side = :buy)
      header = ['Price', 'Amount']
      rows = []
      @book[side].each do |price, amount|
        rows << ['%.6f' % price, '%.6f' % amount]
      end
      table = TTY::Table.new header, rows
      table.render(:ascii, padding: [0, 2], alignment: [:right])
    end

    def [](side)
      @book[side]
    end
  end
end
