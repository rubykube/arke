require 'exchange'
require 'rubykube/api_client'
require 'rubykube/api/market_api'

module Arke::Strategy
  class Copy
    def initialize
      @pair = Arke::Configuration.require!(:pair)
      @orderbook = Arke::Orderbook.new(@pair)
    end

    def pair
      @pair
    end

    def on_order_create(order)
      @orderbook.add(order)
    end

    def on_order_stop(order)
      @orderbook.remove(order.id)
    end

    def start
      target = Arke::Configuration.require!(:target)
      market_api = target['driver'].new(target)

      Arke::Configuration.get(:sources).each do |source|
        EM.run do
          exchange = source['driver'].new(self)
          exchange.start

          process_orders = proc do |order|
            if @orderbook.nil? || @orderbook.empty? || order.nil?
              EM.add_timer(1) { @orderbook.orders_queue.pop(&process_orders) }
            else
              exchange.logger.info("Order: #{order}")
              sleep(0.5)
              market_api.create_order(order)
              @orderbook.remove(order.id)
              EM.next_tick { @orderbook.orders_queue.pop(&process_orders) }
            end
          end

          EM.add_timer(3) { @orderbook.orders_queue.pop(&process_orders) }

          trap('INT') { EM.stop }
          trap('TERM') { EM.stop }
        end
      end
    end
  end
end
