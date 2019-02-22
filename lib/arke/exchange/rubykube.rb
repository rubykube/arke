require 'faraday'
require 'openssl'
require 'json'

module Arke::Exchange
  class Rubykube < Base
    def initialize(config, strategy)
      super

      @api_key = config['key']
      @secret = config['secret']
      @connection = Faraday.new("#{config['host']}/api/v2") do |faraday|
        faraday.adapter Faraday.default_adapter
      end
    end

    def call(action)
      pp 'Rubykube processes action'
      puts action.inspect
      puts

      if action.type == :create_order
        create_order(action.params)
      elsif action.type == :cancel_order
        cancel_order(action.params)
      end
    end

    private

    def create_order(order)
      post(
        'peatio/market/orders',
        {
          market: order.market.downcase,
          side:   order.side.to_s,
          volume: order.amount,
          price:  order.price
        }
      )
    end

    def cancel_order(order)
      post(
        "peatio/market/orders/#{order.id}/cancel"
      )
    end

    def post(path, params = nil)
      response = @connection.post do |req|
        req.headers = generate_headers
        req.url path
        req.body = params.to_json
      end

      Arke::Log.fatal(build_error(response)) if response.env.status != 201

      response
    end

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

    def valid_json?(json)
      begin
        JSON.parse(json)
        true
      rescue StandardError => e
        puts e.message
        false
      end
    end

  end
end
