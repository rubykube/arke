require 'faye/websocket'
require 'eventmachine'
require 'json'
require 'orderbook'

module Arke::Exchange
  class Bitfinex

    attr_reader :orderbook

    def initialize(opts)
      @driver = opts['driver']
      @url = 'wss://%s/ws/2' % opts['host']
      @market = opts['market']
      @orderbook = Arke::Orderbook.new(@market)
    end

    def process_message(msg)
      if msg.kind_of?(Array)
        process_channel_message(msg)
      elsif msg.kind_of?(Hash)
        process_event_message(msg)
      end
    end

    def process_channel_message(msg)
      data = msg[1]

      if data.length == 3
        process_data(data)
      elsif data.length > 3
        data.each { |order| process_data(order) }
      end
    end

    def process_data(data)
      order = build_order(data)
      if order.price.zero?
        @orderbook.delete(order)
      else
        @orderbook.create(order)
      end
    end

    def build_order(data)
      id, price, amount = data
      side = :buy
      if amount.negative?
        side = :sell
        amount = amount * -1
      end
      Arke::Order.new(id, @market, price, amount, side)
    end

    def process_event_message(msg)
      pp msg
      case msg['event']
      when 'auth'
      when 'subscribed'
        Arke::Log.info "Event: #{msg['event']}"
      when 'unsubscribed'
      when 'info'
      when 'conf'
      when 'error'
        Arke::Log.info "Event: #{msg['event']} ignored"
      end
    end

    def print
      puts "Exchange #{@driver} market: #{@market}"
      puts @orderbook.to_s
    end

    def on_open(e)
      sub = {
        event: "subscribe",
        channel: "book",
        pair: @market,
        prec: "R0"
      }

      Arke::Log.info 'Open event' + sub.to_s
      EM.next_tick {
        @ws.send(JSON.generate(sub))
      }
    end

    def on_message(e)
      msg = JSON.parse(e.data)
      process_message(msg)
    end

    def on_close(e)
      Arke::Log.info "Closing code: #{e.code} Reason: #{e.reason}"
    end

    def start
      @ws = Faye::WebSocket::Client.new(@url)

      @ws.on(:open) do |e|
        on_open(e)
      end

      @ws.on(:message) do |e|
        on_message(e)
      end

      @ws.on(:close) do |e|
        on_close(e)
      end
    end

  end
end
