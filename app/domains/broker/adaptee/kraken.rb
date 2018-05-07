# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'broker/adaptee/response_normalizers/kraken'

module Broker
  module Adaptee
    # Responsible for making API request to the exchange
    module Kraken
      extend Dry::Configurable

      setting :api_url, 'https://api.kraken.com/0/', reader: true
      setting :book, 'public/Depth?pair=', reader: true
      setting :pair_name, 'xbtusd', reader: true

      def order_book
        url = URI(api_url + book + pair_name)

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new(url)

        ::Broker::Adaptee::ResponseNormalizers::Kraken.order_book(
          http.request(request).read_body
        )
      end
      module_function :order_book
    end
  end
end
