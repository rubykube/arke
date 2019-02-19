require 'rubykube_api'

module Arke::Exchange
  class Rubykube

    def initialize(strategy)
      @strategy = strategy
      @market_api = RubykubeApi::MarketApi.new(@strategy.target)
    end

    def create_order(order)
      puts "Sending #{order}"
      @market_api.create_order(order)
    end

    def tick
      @strategy.query do |order|
        create_order(order)
        tick
      end
    end
  end
end
