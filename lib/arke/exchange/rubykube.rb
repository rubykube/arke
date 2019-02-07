require 'swagger_client'

module Arke::Exchange
  module Rubykube
    def self.configure(&block)
      SwaggerClient.configure(&block)
      Client.new
    end

    class Client
      def market
        @market_api ||= SwaggerClient::API::Market.new
      end

      def account
        @account_api ||= SwaggerClient::API::Account.new
      end

      def public
        @account_api ||= SwaggerClient::API::Public.new
      end
    end
  end
end
