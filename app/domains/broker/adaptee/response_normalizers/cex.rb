# frozen_string_literal: true

module Broker
  module Adaptee
    module ResponseNormalizers
      # Responsible for normalizing response from API
      module Cex
        def order_book(response)
          json = JSON.parse(response)
          parse(json, 'asks') + parse(json, 'bids')
        end

        def parse(json, side = 'asks')
          json[side].map do |line|
            ActiveSupport::HashWithIndifferentAccess.new(
              broker: name.demodulize.downcase,
              side: side.singularize,
              price: line[0],
              volume: line[1]
            )
          end
        end
        module_function :order_book, :parse
      end
    end
  end
end
