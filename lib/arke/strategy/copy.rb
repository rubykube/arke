require 'action'

module Arke::Strategy
  # This class implements basic copy strategy behaviour
  # * aggreagates orders from sources
  # * push order to target
  class Copy < Base

    # Processes orders and decides what action should be sent to @target
    def call(dax, &block)
      Arke::Log.debug 'Copy startegy called'
      ob = Arke::Orderbook.new(dax[:target].market)
      sources = dax.select { |k, _v| k != :target }

      sources.each { |_key, source| ob.merge!(source.orderbook) }

      diff = dax[:target].open_orders.compare(ob)

      [:buy, :sell].each do |side|
        create = diff[:create][side]
        delete = diff[:delete][side]
        update = diff[:update][side]

        if !create.length.zero?
          yield Arke::Action.new(:order_create, :target, { order: create.first })
        elsif !delete.length.zero?
          yield Arke::Action.new(:order_stop, :target, { order: delete.first })
        elsif !update.length.zero?
          yield Arke::Action.new(:order_stop, :target, { order: update.first })
        end
      end
    end
  end
end
