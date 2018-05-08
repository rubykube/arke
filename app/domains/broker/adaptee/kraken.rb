# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'broker/adaptee/response_normalizers/kraken'

module Broker
  module Adaptee
    # Responsible for making API request to the exchange
    module Kraken
      extend Dry::Configurable

      def order_book
        uri = URI.join(
          Broker::Settings::Kraken.api.uri,
          "#{Broker::Settings::Kraken.api.version}/",
          Broker::Settings::Kraken.order_book.uri
        )
        uri.query = URI.encode_www_form(
          pair: Broker::Settings::Kraken.pair,
          count: Broker::Settings::Kraken.order_book.depth
        )

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new(uri)
        ::Broker::Adaptee::ResponseNormalizers::Kraken.order_book(
          http.request(request).read_body
        )
      end
      module_function :order_book
    end
  end
end
