require 'exchange'

module Arke::Strategy
  class Copy
    attr_reader :pair, :target

    def initialize
      @target = Arke::Configuration.require!(:target)
      @pair = Arke::Configuration.require!(:pair)
      @orderbook = Arke::Orderbook.new(@pair)
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

        process_orders = proc do |order|
          if @orderbook.nil? || @orderbook.empty? || order.nil?
            EM.add_timer(1) { @orderbook.orders_queue.pop(&process_orders) }
          else
            target_exchange.logger.info("Order: #{order}")
            sleep(0.5)
            target_exchange.create_order(order)
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
