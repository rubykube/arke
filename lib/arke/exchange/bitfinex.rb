module Arke::Exchange
  class Bitfinex < Base
    def call(action)
      # we can use separate websocket worker as event emitter
      # it solves a problem with queue.pop, websocket will push messages
      # exchange handles parsing and subscription logic
      Arke::Log.debug "Bitfinex processes action #{action}"

      if action.type == :websocket
        # parsing and sending to strategy
        # @strategy.push_order
      end
    end
  end
end
