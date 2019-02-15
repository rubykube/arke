require 'exchange/bitfinex'
require 'rubykube/api_client'
require 'rubykube/api/market_api'

module Arke::Strategy
  class Copy

    def start
      EM.run do

        market_api = Rubykube::MarketApi.new(
          Arke.configuration.host,
          Arke.configuration.api_key['key'],
          Arke.configuration.api_key['secret']
        )

        bf = Arke::Exchange::Bitfinex.new
        bf.start

        process_orders = Proc.new do |order|
          if bf.orderbook.nil? || bf.orderbook.empty? || order.nil?
            EM.add_timer(1) { bf.orderbook.orders_queue.pop(&process_orders) }
          else
            bf.logger.info("Order: #{order.to_s}")
            sleep(0.5)
            market_api.create_order(order)
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
