require 'faraday'
require 'openssl'

module RubykubeApi
  class ApiClient
    def initialize(params)
      @api_key = params['key']
      @secret = params['secret']
      @connection = Faraday.new("#{params['host']}/api/v2") do |faraday|
        faraday.adapter Faraday.default_adapter
      end
    end

    def get(path, params = nil)
      response = @connection.get do |req|
        req.headers = generate_headers
        req.url path
        req.body = params.to_json
      end

      Arke::Log.fatal(build_error(response)) if response.env.status != 200

      response
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

    def build_error(response)
      if valid_json?(response.body)
        body = JSON.parse(response.body)
      else
        "Code: #{response.env.status} Message: #{response.env.reason_phrase}"
      end
    end

    def valid_json?(json)
      begin
        JSON.parse(json)
        true
      rescue Exception => e
        false
      end
    end

  end
end
