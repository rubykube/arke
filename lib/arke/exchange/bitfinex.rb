require 'faye/websocket'
require 'eventmachine'
require 'json'
require 'exchange/base'
require 'orderbook'

module Arke::Exchange
  class Bitfinex < Base

    attr_reader :orderbook

    def initialize(opts)
      super

      @url = 'wss://%s/ws/2' % opts['host']
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
      if data[1].zero?
        @orderbook.delete(order)
      else
        @orderbook.update(order)
      end
    end

    def build_order(data)
      price, _count, amount = data
      side = :buy
      if amount.negative?
        side = :sell
        amount = amount * -1
      end
      Arke::Order.new(@market, price, amount, side)
    end

    def process_event_message(msg)
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

    def on_open(e)
      sub = {
        event: "subscribe",
        channel: "book",
        symbol: @market,
        prec: "P0",
        freq: "F0",
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
