require 'exchange'

module Arke::Strategy
  class Copy
    attr_reader :pair, :target, :orderbook

    def initialize
      @target = Arke::Configuration.require!(:target)
      @pair = Arke::Configuration.require!(:pair)
      @orderbook = Arke::Orderbook.new(@pair)
    end

    def query(&callback)
      @orderbook.query do |order|
        yield order
      end
    end

    def on_order_create(order)
      @orderbook.add(order)
    end

    def on_order_stop(order)
      @orderbook.remove(order.id)
    end

    def start
      target_exchange = @target['driver'].new(self)

      EM.run do
        Arke::Configuration.get(:sources).each do |source|
          EM.run do
            exchange = source['driver'].new(self)
            exchange.start
          end
        end

        EM.run do
          target_exchange.tick
        end

        trap('INT') { EM.stop }
        trap('TERM') { EM.stop }
      end
    end
  end
end
