require 'action'

module Arke::Strategy
  # This class implements basic copy strategy behaviour
  # * aggreagates orders from sources
  # * push order to target
  class Copy < Base

    # Processes orders and decides what action should be sent to @target
    def call(dax, &block)
      sources = dax.select { |k, _v| k != :target }
      ob = merge_orderbooks(sources, dax[:target].market)
      ob = scale_amounts(ob)

      diff = dax[:target].open_orders.get_diff(ob)

      [:buy, :sell].each do |side|
        create = diff[:create][side]
        delete = diff[:delete][side]
        update = diff[:update][side]

        if !create.length.zero?
          order = create.first
          scaled_order = Arke::Order.new(order.market, order.price, order.amount, order.side)
          yield Arke::Action.new(:order_create, :target, { order: scaled_order })
        elsif !delete.length.zero?
          yield Arke::Action.new(:order_stop, :target, { id: delete.first })
        elsif !update.length.zero?
          order = update.first
          if order.amount > 0
            scaled_order = Arke::Order.new(order.market, order.price, order.amount, order.side)
            yield Arke::Action.new(:order_create, :target, { order: scaled_order })
          end
        end
      end
    end

    def scale_amounts(orderbook)
      ob = Arke::Orderbook.new(orderbook.market)

      [:buy, :sell].each do |side|
        orderbook[side].each do |price, amount|
          ob[side][price] = amount * @volume_ratio
        end
      end

      ob
    end

    def merge_orderbooks(sources, market)
      ob = Arke::Orderbook.new(market)

      sources.each do |_key, source|
        source_book = source.orderbook.clone

        # discarding 1st level
        source_book[:sell].shift
        source_book[:buy].shift

        ob.merge!(source_book)
      end

      ob
    end
  end
end
