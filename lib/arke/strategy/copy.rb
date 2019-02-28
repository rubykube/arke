require 'action'

module Arke::Strategy
  # This class implements basic copy strategy behaviour
  # * aggreagates orders from sources
  # * push order to target
  class Copy < Base

    # Processes orders and decides what action should be sent to @target
    def call(target, dax, &block)
      Arke::Log.debug 'Copy startegy called'
      puts dax[:bitfaker].print
      dax[:bitfaker].orderbook[:buy].each { |order|
        yield Arke::Action.new(:ping, { exchange: 'target', order: order })
      }
      dax[:bitfaker].orderbook[:sell].each { |order|
        yield Arke::Action.new(:ping, { exchange: 'target', order: order })
      }
    end
  end
end
