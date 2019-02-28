require 'faye/websocket'
require 'eventmachine'
require 'json'
require 'order'
require 'action'

module Arke::Exchange
  class Bitfinex

    def initialize(strategy)
      @url = 'wss://api.bitfinex.com/ws/2'
      @strategy = strategy
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
      order = parse_ws_data(data)
      order.amount.zero? ? push(:cancel_order, order) : push(:create_order, order)
    end

    def parse_ws_data(data)
      data[2].positive? ? build_buy_order(data) : build_sell_order(data)
    end

    def push(action, order)
      @strategy.push(Arke::Action.new(action, order))
    end

    def build_buy_order(data)
      Arke::Order.new(
        data[0],
        @strategy.pair,
        data[1],
        data[2],
        :buy
      )
    end

    def build_sell_order(data)
      Arke::Order.new(
        data[0],
        @strategy.pair,
        data[1],
        data[2] * -1,
        :sell
      )
    end

    def process_event_message(msg)
      case msg['event']
      when 'auth'
      when 'subscribed'
        handle_subscribed_event(msg)
      when 'unsubscribed'
      when 'info'
      when 'conf'
      when 'error'
        Arke::Log.info "Event: #{msg['event']} ignored"
      end
    end

    def handle_subscribed_event(msg)
      Arke::Log.info "Event: #{msg['event']}"
    end

    def on_open(e)
      sub = {
        event: "subscribe",
        channel: "book",
        market: @market,
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

    def print
      @map.each { |item| pp item }
    end
  end
end
