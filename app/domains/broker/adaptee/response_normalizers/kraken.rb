# frozen_string_literal: true

module Broker
  module Adaptee
    module ResponseNormalizers
      # Responsible for normalizing response from API
      module Kraken
        def order_book(response)
          json = JSON.parse(response)['result']['XXBTZUSD']

          parse(json, Broker::Settings::General.ask_side) +
            parse(json, Broker::Settings::General.bid_side)
        end

        def parse(json, side = Broker::Settings::General.ask_side)
          json[side].map do |line|
            ActiveSupport::HashWithIndifferentAccess.new(
              broker: name.demodulize.downcase,
              side: side.singularize,
              price: BigDecimal(line[0].to_s),
              volume: BigDecimal(line[1].to_s)
            )
          end
        end
        module_function :order_book, :parse
      end
    end
  end
end
