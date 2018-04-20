# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'broker/adaptee/response_normalizers/bitfinex'

module Broker
  module Adaptee
    # Responsible for making API request to the exchange
    module Bitfinex
      extend Dry::Configurable

      setting :api_url, 'https://api.bitfinex.com/v1/', reader: true
      setting :book, 'book/', reader: true
      setting :pair_name, 'btcusd', reader: true

      def order_book
        url = URI(api_url + book + pair_name)

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new(url)

        ::Broker::Adaptee::ResponseNormalizers::Bitfinex.order_book(
          http.request(request).read_body
        )
      end
      module_function :order_book
    end
  end
end
