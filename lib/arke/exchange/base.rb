module Arke::Exchange

  # Base class for all exchanges
  class Base
    attr_reader :queue, :min_delay, :open_orders, :market
    attr_accessor :timer

    def initialize(opts)
      @market  = opts['market']
      @driver  = opts['driver']
      @api_key = opts['key']
      @secret  = opts['secret']
      @queue   = EM::Queue.new
      @timer   = nil

      rate_limit = opts['rate_limit'] || 1.0
      rate_limit = 1.0 if rate_limit <= 0
      @min_delay = 1.0 / rate_limit

      @open_orders = Arke::OpenOrders.new(@market)
    end

    def start; end

    def print
      return unless @orderbook
      puts "Exchange #{@driver} market: #{@market}"
      puts @orderbook.print(:buy)
      puts @orderbook.print(:sell)
    end

    def build_error(response)
      JSON.parse(response.body)
    rescue StandardError => e
      "Code: #{response.env.status} Message: #{response.env.reason_phrase}"
    end
  end
end
