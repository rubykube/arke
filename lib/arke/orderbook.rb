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

    def update_order(order)
      if old_order = find(order.side, order.id)
        if old_order.price != order.price
          remove old_order
          add order
        else
          update old_order, order
        end
      end
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

    def find(side, order_id)
      node = @book[side].find{ |k,v| v.map(&:id).include?(order_id) }
      node.last.find { |order| order.id == order_id } unless node.nil?
    end

    def add(order)
      @book[order.side][order.price] ||= []
      @book[order.side][order.price].push order
    end

    def remove(order)
      @book[order.side][order.price].delete order
      @book[order.side].delete(order.price) if @book[order.side][order.price].empty?
    end

    def update(old_order, new_order)
      @book[old_order.side][old_order.price].map! { |o| o.id == old_order.id ? new_order : o }
    end

  end
end
