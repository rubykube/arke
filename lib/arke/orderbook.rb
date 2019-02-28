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

    def create(order)
      add(order) unless contains?(order)
    end

    def delete(order)
      remove(order) if order && contains?(order)
    end

    def contains?(order)
      return false if @book[order.side][order.price].nil?
      @book[order.side][order.price].find { |o| o.id == order.id } ? true : false
    end

    # get with the lowest price
    def get(side)
      @book[side].first.last
    end

    def print(side = :buy)
      header = ['Price', 'Amount']
      rows = []
      @book[side].each {|price, orders|
        rows << ['%.6f' % price, '%.6f' % orders.map { |h| h.amount }.sum]
      }
      table = TTY::Table.new header, rows
      table.render(:ascii, padding: [0, 2], alignment: [:right])
    end

    def [](side)
      @book[side]
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
