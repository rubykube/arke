require 'exchange/base'

module Arke::Exchange
  # This class holds Rubykube Exchange logic implementation
  class Rubykube < Base

    # Takes config (hash), strategy(+Arke::Strategy+ instance)
    # * +strategy+ is setted in +super+
    # * creates @connection for RestApi
    def initialize(config)
      super

      @connection = Faraday.new(config['host']) do |builder|
        builder.response :logger
        builder.response :json
        builder.adapter :em_synchrony
      end
    end

    # Ping the api
    def ping
      @connection.get '/api/v2/barong/identity/ping'
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
      @open_orders[response.env.body['id']] = order if response.env.status == 201 && response.env.body['id']
      response
    end

    # Takes +order+ (+Arke::Order+ instance)
    # * cancels +order+ via RestApi
    def stop_order(order)
      post(
        "peatio/market/orders/#{order.id}/cancel"
      )
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

    def build_error(response)
      if valid_json?(response.body)
        JSON.parse(response.body)
      else
        "Code: #{response.env.status} Message: #{response.env.reason_phrase}"
      end
    end

    # Helper method, checks for +json+ integrity
    def valid_json?(json)
      begin
        JSON.parse(json)
        true
      rescue StandardError => e
        Arke::Log.error e.message
        false
      end
    end

  end
end
