require 'order'

module Arke
  class OpenOrders
    def initialize(market)
      @market = market
      @book = {
        buy: {},
        sell: {}
      }
    end

    def price_level(side, price)
      @book[side][price]
    end

    def contains?(side, price)
      !(@book[side][price].nil? || @book[side][price].empty?)
    end

    def price_amount(side, price)
      @book[side][price].sum { |_id, order| order.amount }
    end

    def add_order(order, id)
      @book[order.side][order.price] ||= {}
      @book[order.side][order.price][id] = order
    end

    def remove_order(id)
      @book[:sell].each { |k , v| v.delete(id)}
      @book[:buy].each { |k, v| v.delete(id)}
    end

    def get_diff(orderbook)
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
            diff[:create][side].push(Arke::Order.new(@market, price, amount, side))
          else
            our_amount = price_amount(side, price)
            # creating additioanl order to adjust volume
            if our_amount != amount
              diff[:update][side].push(Arke::Order.new(@market, price, amount - our_amount, side))
            end
          end
        end

        our.each do |_price, hash|
          hash.each do |id, order|
            diff[:delete][side].push(id) unless orderbook.contains?(order)
          end
        end
      end

      diff
    end
  end
end
