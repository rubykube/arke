require 'orderbook'
require 'json'
require 'openssl'

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
      @rest_api_connection = Faraday.new("https://#{opts['host']}") do |builder|
        builder.adapter :em_synchrony
        builder.headers['Content-Type'] = 'application/x-www-form-urlencoded'
      end
    end

    # TODO: remove EM (was used only for debug)
    def start
      update_orderbook

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

    def build_order(data, side)
      Arke::Order.new(
        @market,
        data[0].to_f,
        data[1].to_f,
        side
      )
    end

    def update_orderbook
      snapshot = JSON.parse(@connection.get("api/v1/depth?symbol=#{@market.upcase}&limit=1000").body)
      snapshot['bids'].each do |order|
        @orderbook.update(
          build_order(order, :buy)
        )
      end
      snapshot['asks'].each do |order|
        @orderbook.update(
          build_order(order, :sell)
        )
      end
      @orderbook
    end

    def create_order(order)
      timestamp = Time.now.to_i * 1000
      body = {
        symbol: @market.upcase,
        side: order.side.upcase,
        type: 'LIMIT',
        timeInForce: 'GTC',
        quantity: order.amount.to_f,
        price: order.price.to_f,
        recvWindow: '5000',
        timestamp: timestamp
      }

      post('api/v3/order', body)
    end

    def generate_signature(data, timestamp)
      query = ""
      data.each { |key, value| query << "#{key}=#{value}&" }
      OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, query.chomp('&'))
    end

    private

    def post(path, params = nil)
      request = @rest_api_connection.post(path) do |req|
        req.headers['X-MBX-APIKEY'] = @api_key
        req.body = URI.encode_www_form(generate_body(params))
      end

      Arke::Log.fatal(build_error(request)) if request.env.status != 200
      request
    end

    def generate_body(data)
      query = ""
      data.each { |key, value| query << "#{key}=#{value}&" }
      sig = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, query.chomp('&'))
      data.merge(signature: sig)
    end
  end
end
