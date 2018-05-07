# frozen_string_literal: true

module Broker
  module Adaptee
    module ResponseNormalizers
      # Responsible for normalizing response from API
      module Bitfinex
        def order_book(response)
          json = JSON.parse(response)
          parse(json, Broker::Settings.quote_aggregation.ask_side) +
            parse(json, Broker::Settings.quote_aggregation.bid_side)
        end

        def parse(json, side = Broker::Settings.quote_aggregation.ask_side)
          json[side].map do |line|
            ActiveSupport::HashWithIndifferentAccess.new(
              broker: name.demodulize.downcase,
              side: side.singularize,
              price: line['price'],
              volume: line['amount']
            )
          end
        end

        def method_name

        end
        module_function :order_book, :parse
      end
    end
  end
end
