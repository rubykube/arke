# encoding: UTF-8
# frozen_string_literal: true

require 'pp'
require 'faye/websocket'
require 'eventmachine'
require 'json'

require_relative '../order'
require_relative '../price_level'
require_relative '../orderbook'

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
        update_order(data)
      elsif data.length > 3
        data.each { |order| update_order(order) }
      end
    end

    def update_order(data)
      id, price, amount = data
      order = Arke::Order.new(id, @strategy.pair, price, amount)

      if price.zero?
        @strategy.on_order_stop(order)
      else
        @strategy.on_order_create(order)
      end
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
      # @map[msg['chanId']] = {
        # info: msg,
        # book: Arke::Orderbook.new(msg['pair'])
      # }
    end

    def on_open(e)
      Arke::Log.info 'Open event'
      sub = {
        event: "subscribe",
        channel: "book",
        pair: @strategy.pair,
        prec: "R0"
      }

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
