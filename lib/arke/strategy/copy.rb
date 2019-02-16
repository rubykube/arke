require 'exchange'
require 'rubykube/api_client'
require 'rubykube/api/market_api'

module Arke::Strategy
  class Copy
    def start
      target = Arke::Configuration.require!(:target)
      market_api = target['driver'].new(target)

      Arke::Configuration.get(:sources).each do |source|
        EM.run do

          exchange = source['driver'].new
          exchange.start

          process_orders = proc do |order|
            if exchange.orderbook.nil? || exchange.orderbook.empty? || order.nil?
              EM.add_timer(1) { exchange.orderbook.orders_queue.pop(&process_orders) }
            else
              exchange.logger.info("Order: #{order}")
              sleep(0.5)
              market_api.create_order(order)
              exchange.orderbook.remove(order.id)
              EM.next_tick { exchange.orderbook.orders_queue.pop(&process_orders) }
            end
          end

          EM.add_timer(3) { exchange.orderbook.orders_queue.pop(&process_orders) }

          trap('INT') { EM.stop }
          trap('TERM') { EM.stop }
        end
      end
    end
  end
end
