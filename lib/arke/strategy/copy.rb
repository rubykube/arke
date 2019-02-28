require 'action'

module Arke::Strategy
  # This class implements basic copy strategy behaviour
  # * aggreagates orders from sources
  # * push order to target
  class Copy < Base

    # Processes orders and decides what action should be sent to @target
    def call(target, dax, &block)
      Arke::Log.debug 'Copy startegy called'
      dax.each do |name, ex|
        puts ex.print
        yield Arke::Action.new(:ping, { exchange: 'target' })
        ex.orderbook[:buy].each { |order|
          yield Arke::Action.new(:order_create, { exchange: 'target', order: order })
        }
        ex.orderbook[:sell].each { |order|
          yield Arke::Action.new(:order_create, { exchange: 'target', order: order })
        }
      end
    end
  end
end
