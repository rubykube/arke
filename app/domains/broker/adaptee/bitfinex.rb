# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'broker/adaptee/response_normalizers/bitfinex'

module Broker
  module Adaptee
    # Responsible for making API request to the exchange
    module Bitfinex
      def order_book
        uri = URI(
          Broker::Settings::Bitfinex.uri + '/' +
          Broker::Settings::Bitfinex.version + '/' +
          Broker::Settings::Bitfinex.order_book.uri + '/' +
          Broker::Settings::Bitfinex.pair
        )

        uri.query = URI.encode_www_form(
          limit_bids: Broker::Settings::Bitfinex.order_book.depth,
          limit_asks: Broker::Settings::Bitfinex.order_book.depth,
          group: Broker::Settings::Bitfinex.order_book.group
        )

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        request = Net::HTTP::Get.new(uri)

        ::Broker::Adaptee::ResponseNormalizers::Bitfinex.order_book(
          http.request(request).read_body
        )
      end
      module_function :order_book
    end
  end
end
