require 'orderbook'
require 'json'

module Arke::Exchange
  class Binance < Base
    attr_reader :last_update_id
    attr_accessor :orderbook

    def initialize(opts)
      super

      @url = "wss://stream.binance.com:9443/ws/#{@market}@depth"
      @connection = Faraday.new("https://www.binance.com") do |builder|
        builder.adapter :em_synchrony
      end

      @orderbook = Arke::Orderbook.new(@market)
      @last_update_id = 0
    end

    # TODO: remove EM (was used only for debug)
    def start
      get_snapshot

      @ws = Faye::WebSocket::Client.new(@url)

      @ws.on(:message) do |e|
        on_message(e)
      end
    end

    def on_message(mes)
      data = JSON.parse(mes.data)
      return if @last_update_id >= data['U']
      @last_update_id = data['u']
      process(data['b'], :buy) unless data['b'].empty?
      process(data['a'], :sell) unless data['a'].empty?
    end

    def process(data, side)
      data.each do |order|
        if order[1].to_f.zero?
          @orderbook.delete(build_order(order, side))
          next
        end

        orderbook.update(
          build_order(order, side)
        )
      end
    end

    def build_order(data, side)
      Arke::Order.new(
        @market,
        data[0],
        data[1],
        side
      )
    end

    def get_snapshot
      snapshot = JSON.parse(@connection.get("api/v1/depth?symbol=#{@market.upcase}&limit=1000").body)
      @last_update_id = snapshot['lastUpdateId']
      process(snapshot['bids'], :buy)
      process(snapshot['asks'], :sell)
    end
  end
end
