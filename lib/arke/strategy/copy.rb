require 'action'

module Arke::Strategy
  # This class implements basic copy strategy behaviour
  # * aggreagates orders from sources
  # * push order to target
  class Copy < Base

    # Processes orders and decides what action should be sent to @target
    def call(dax, &block)
      ob = Arke::Orderbook.new(dax[:target].market)
      sources = dax.select { |k, _v| k != :target }

      sources.each { |_key, source| ob.merge!(source.orderbook) }
      ob.book[:buy].shift
      ob.book[:sell].shift

      diff = dax[:target].open_orders.get_diff(ob)

      [:buy, :sell].each do |side|
        create = diff[:create][side]
        delete = diff[:delete][side]

        if !create.length.zero?
          order = create.first
          scaled_order = Arke::Order.new(order.market, order.price, order.amount * @volume_ratio, order.side)
          yield Arke::Action.new(:order_create, :target, { order: scaled_order })
        elsif !delete.length.zero?
          yield Arke::Action.new(:order_stop, :target, { id: delete.first })
        end
      end
    end
  end
end
