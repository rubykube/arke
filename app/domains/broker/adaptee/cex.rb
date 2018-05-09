# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'broker/adaptee/response_normalizers/cex'

module Broker
  module Adaptee
    # Responsible for making API request to the exchange
    module Cex
      def order_book
        uri = URI(
          Broker::Settings::Cex.api.uri +
          Broker::Settings::Cex.order_book.uri +
          Broker::Settings::Cex.api.pair
        )

        uri.query = URI.encode_www_form(
          depth: Broker::Settings::Cex.order_book.depth
        )

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        request = Net::HTTP::Get.new(uri)

        ::Broker::Adaptee::ResponseNormalizers::Cex.order_book(
          http.request(request).read_body
        )
      end
      module_function :order_book
    end
  end
end
