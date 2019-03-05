require 'rbtree'
require 'order'

module Arke
  class OpenOrders
    def initialize
      @book = {
        buy: ::RBTree.new,
        sell: ::RBTree.new
      }
    end

    def contains?(side, price)
      !@book[side][price].nil?
    end

    def add_order(order, id)
      @book[order.side][order.price] = { id: id, order: order }
    end

    def get_id(side, price)
      @book[side][price][:id]
    end

    def compare(orderbook)
      diff = {
        create: { buy: [], sell: [] },
        delete: { buy: [], sell: [] },
        update: { buy: [], sell: [] }
      }

      [:buy, :sell].each do |side|
        our = @book[side]
        their = orderbook.book[side]

        their.each do |price, amount|
          if !contains?(side, price)
            diff[:create][side].push(Arke::Order.new('ethusd', price, amount, side))
          else
            diff[:update][side].push({ id: get_id(side, price), order: Arke::Order.new('ethusd', price, amount, side) })
          end
        end

        our.each do |_price, info|
          diff[:delete][side].push(info) if !orderbook.contains?(info[:order])
        end
      end

      diff
    end
  end
end

