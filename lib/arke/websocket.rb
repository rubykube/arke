
# WIP
# need a way to kill it properly
module Arke
  class Websocket
    def initialize(subscriber)
      @subscriber = subscriber
    end

    def run
      loop do
        sleep(0.7)
        Arke::Log.debug 'Websocket sends messages to subscribers'
        action = Arke::Action.new(:websocket, { msg: 'fake_message' })
        @subscriber.push(action)
      end
    end

    def subscribe; end
  end
end
