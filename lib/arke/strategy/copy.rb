require 'exchange'
require 'redis'

module Arke::Strategy
  class Copy
    attr_reader :pair, :target

    def initialize
      @target = Arke::Configuration.require!(:target)
      @pair = Arke::Configuration.require!(:pair)
      @orderbook = Arke::Orderbook.new(@pair)
      @redis = Redis.new
      @prev_state = []
    end

    def on_order_create(order)
      @redis.set('arke_' + order.id.to_s, order.to_json)
    end

    def on_order_stop(order)
      # Rubykube::MarketApi.cancel_order(order)
      @redis.del('arke_' + order.id.to_s)
    end

    def arke_keys
      @redis.keys.select { |key| key.include? 'arke'}
    end

    # Method for sending orders from redis to target api
    def start_pushing(target_exchange)
      start_pushing(target_exchange) if arke_keys.nil?

      order = []
      arke_keys.each do |key|
        order = JSON.parse(@redis.get(key))
        break if order.last == 'new'
      end

      pp 'Pushing ' + order.to_s

      order[5] = 'done'
      @redis.set('arke_' + order.first.to_s, order.to_json)
      sleep 0.5
      start_pushing(target_exchange)
    end

    def process_orders
      if arke_keys.empty?
        EM.next_tick { process_orders }
      else
        # Arke::Log.info("Order: #{order}")
        EM.next_tick { process_orders }
      end
    end

    def start
      target_exchange = @target['driver'].new(self)
      Thread.new { start_pushing(target_exchange) }

      EM.run do
        Arke::Configuration.get(:sources).each do |source|
          exchange = source['driver'].new(self)
          exchange.start
        end

        process_orders

        trap('INT') { EM.stop }
        trap('TERM') { EM.stop }
      end
    end
  end
end
