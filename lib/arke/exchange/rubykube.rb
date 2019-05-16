require 'exchange/base'
require 'open_orders'

module Arke::Exchange
  # This class holds Rubykube Exchange logic implementation
  class Rubykube < Base

    # Takes config (hash), strategy(+Arke::Strategy+ instance)
    # * +strategy+ is setted in +super+
    # * creates @connection for RestApi
    def initialize(config)
      super

      @url = "ws://www.app.local/api/v2/ranger/private/?stream=order"
      @connection = Faraday.new(:url => "#{config['host']}/api/v2") do |builder|
        # builder.response :logger
        builder.response :json
        builder.adapter :em_synchrony
      end
    end

    def start
      save_open_orders

      @ws = Faye::WebSocket::Client.new(@url, [], { :headers => generate_headers })

      @ws.on(:open) do |e|
        p [:open]
      end

      @ws.on(:message) do |e|
        on_message(e)
      end

      @ws.on(:close) do |e|
        on_close(e)
        @ws = nil
      end
    end

    # Ping the api
    def ping
      @connection.get '/barong/identity/ping'
    end

    # Takes +order+ (+Arke::Order+ instance)
    # * creates +order+ via RestApi
    def create_order(order)
      response = post(
        'peatio/market/orders',
        {
          market: order.market.downcase,
          side:   order.side.to_s,
          volume: order.amount,
          price:  order.price
        }
      )
      response
    end

    # Takes +order+ (+Arke::Order+ instance)
    # * cancels +order+ via RestApi
    def stop_order(id)
      response = post(
        "peatio/market/orders/#{id}/cancel"
      )
      @open_orders.remove_order(id)

      response
    end

    def get_balances
      response = get('peatio/account/balances')
      response.body
    end

    def save_open_orders
      max_limit = 1000

      total = get('peatio/market/orders', { market: "#{@market.downcase}", limit: 1, page: 1, state: 'wait' }).headers['Total']
      (total.to_f / max_limit.to_f).ceil.times do |page|
        response = get('peatio/market/orders', { market: "#{@market.downcase}", limit: max_limit, page: page + 1, state: 'wait' }).body.each do |o|
          order = Arke::Order.new(o['market'].upcase, o['price'].to_f, o['remaining_volume'].to_f, o['side'].to_sym)
          @open_orders.add_order(order, o['id'])
        end
      end
    end

    private

    # Helper method to perform post requests
    # * takes +conn+ - faraday connection
    # * takes +path+ - request url
    # * takes +params+ - body for +POST+ request
    def post(path, params = nil)
      response = @connection.post do |req|
        req.headers = generate_headers
        req.url path
        req.body = params.to_json
      end
      Arke::Log.fatal(build_error(response)) if response.env.status != 201
      response
    end

    def get(path, params = nil)
      response = @connection.get do |req|
        req.headers = generate_headers
        req.url path, params
      end
      Arke::Log.fatal(build_error(response)) if response.env.status != 200
      response
    end

    # Helper method, generates headers to authenticate with +api_key+
    def generate_headers
      nonce = Time.now.to_i.to_s
      {
        'X-Auth-Apikey' => @api_key,
        'X-Auth-Nonce' => nonce,
        'X-Auth-Signature' => OpenSSL::HMAC.hexdigest('SHA256', @secret, nonce + @api_key),
        'Content-Type' => 'application/json'
      }
    end

    def process_message(msg)
      if msg['order'] && msg['order']['market'] == @market.downcase
        ord = msg['order']
        side = ord['kind'] == 'bid' ? :buy : :sell
        case ord['state']
        when 'wait'
          order = Arke::Order.new(ord['market'].upcase, ord['price'].to_f, ord['remaining_volume'].to_f, side)
          @open_orders.add_order(order, ord['id'])
        when 'done'
          @open_orders.remove_order(ord['id']) if @open_orders.exist?(side, ord['price'].to_f, ord['id'])
        when 'cancel'
          @open_orders.remove_order(ord['id']) if @open_orders.exist?(side, ord['price'].to_f, ord['id'])
        end
      end
    end

    def on_message(e)
      msg = JSON.parse(e.data)
      process_message(msg)
    end

    def on_close(e)
      Arke::Log.info "Closing code: #{e.code} Reason: #{e.reason}"
    end
  end
end
