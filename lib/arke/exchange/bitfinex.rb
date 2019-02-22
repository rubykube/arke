module Arke::Exchange
  class Bitfinex < Base
    def call(action)
      # we can use separate websocket worker as event emitter
      puts "Bitfinex processes action"
      puts action.inspect
    end
  end
end
