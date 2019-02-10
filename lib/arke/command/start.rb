require 'exchange/bitfinex'

module Arke
  module Command
    class Start < Clamp::Command
      def execute
        EM.run do

          api = Arke::Exchange::Rubykube.configure do |config|
            config.api_key = "2e3f4ce4f72c85f1"
            config.api_key_secret = "551916d95da79fc7cb49bd2c0334cc27"
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
