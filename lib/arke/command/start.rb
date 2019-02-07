require 'exchange/bitfinex'

module Arke
  module Command
    class Start < Clamp::Command
      def execute
        EM.run do

          api = Arke::Exchange::Rubykube.configure do |config|
            config.api_key = "11f345e5b3c601a7"
            config.api_key_secret = "1fb8642bb82ad6bb8df7c1872ad211fd"
            # config.debugging = true
          end

          bf = Arke::Exchange::Bitfinex.new
          bf.start

          process_orders = Proc.new do |order|
            if bf.orderbook.nil? || bf.orderbook.empty? || order.nil?
              EM.add_timer(1) { bf.orderbook.orders_queue.pop(&process_orders) }
            else
              bf.logger.info("Order: #{order}")
              api.market.create_order(order)
              bf.orderbook.remove(order.id)
              EM.next_tick { bf.orderbook.orders_queue.pop(&process_orders) }
            end
          end

          EM.add_timer(3) { bf.orderbook.orders_queue.pop(&process_orders) }

          trap("INT") { EM.stop }
          trap("TERM") { EM.stop }
        end
      end
    end
  end
end
