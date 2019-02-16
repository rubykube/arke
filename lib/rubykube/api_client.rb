require 'faraday'
require 'openssl'

module Rubykube
  class ApiClient
    def initialize(params)
      @api_key = params['key']
      @secret = params['secret']
      @connection = Faraday.new("#{params['host']}/api/v2") do |faraday|
        faraday.adapter Faraday.default_adapter
      end
    end

    def get(path, params = nil)
      @connection.get do |req|
        req.headers = generate_headers
        req.url path
        req.body = params.to_json
      end
    end

    def post(path, params = nil)
      @connection.post do |req|
        req.headers = generate_headers
        req.url path
        req.body = params.to_json
      end
    end

    private

    def generate_headers
      nonce = Time.now.to_i.to_s
      {
        'X-Auth-Apikey' => @api_key,
        'X-Auth-Nonce' => nonce,
        'X-Auth-Signature' => OpenSSL::HMAC.hexdigest('SHA256', @secret, nonce + @api_key),
        'Content-Type' => 'application/json'
      }
    end
  end
end
