require 'rubykube_api'

module Arke::Exchange
  class Rubykube

    def initialize(strategy)
      @strategy = strategy
      @market_api = RubykubeApi::MarketApi.new(@strategy.target)

      Arke::Performance.add_unit(:processed_orders, 'orders')
    end

    def create_order(order)
      @market_api.create_order(order)
      Arke::Performance.accept_unit(:processed_orders)
    end
  end
end
