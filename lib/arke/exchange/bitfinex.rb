# encoding: UTF-8
# frozen_string_literal: true

require 'pp'
require 'logger'
require 'faye/websocket'
require 'eventmachine'
require 'json'

require_relative '../order'
require_relative '../price_level'
require_relative '../orderbook'

module Arke::Exchange
  class Bitfinex

    def initialize
      @log = Logger.new(STDOUT)
      @url = "wss://api.bitfinex.com/ws/2"
      @map = {}
    end

    def process_message(msg)
      if msg.kind_of?(Array)
        process_channel_message(msg)
      elsif msg.kind_of?(Hash)
        process_event_message(msg)
      end
    end

    def process_channel_message(msg)
      book = @map[msg[0]][:book]
      data = msg[1]
      if data.length == 3
        update_order(book, data)
      elsif data.length > 3
        data.each { |order|
          update_order(book, order)
        }
      end
    end

    def update_order(book, data)
      id, price, amount = data
      if price == 0
        book.remove(id)
      else
        book.add(Arke::Order.new(id, 'BTCUSD', price, amount))
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
        @log.info "Event: #{msg['event']} ignored"
      end
    end

    def handle_subscribed_event(msg)
      @map[msg['chanId']] = {
        info: msg,
        book: Arke::Orderbook.new(msg['pair'])
      }
    end

    def on_open(e)
      @log.info 'Open event'
      sub = {
        event: "subscribe",
        channel: "book",
        pair: "BTCUSD",
        prec: "R0"
      }
      EM.next_tick {
        @ws.send(JSON.generate(sub))
      }
    end

    def on_message(e)
      @log.info "Message: #{e.data}"
      msg = JSON.parse(e.data)
      process_message(msg)
    end

    def on_close(e)
      @log.info "Closing code: #{event.code} Reason: #{event.reason}"
    end

    def start
      EM.run {
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

        Signal.trap("INT")  { print; EventMachine.stop }
        Signal.trap("TERM") { print; EventMachine.stop }
      }
    end

    def print
      @map.each { |item| pp item }
    end

  end
end
