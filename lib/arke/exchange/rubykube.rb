require 'rubykube_api'

module Arke::Exchange
  class Rubykube
    attr_reader :logger

    def initialize(strategy)
      @strategy = strategy
      @market_api = RubykubeApi::MarketApi.new(@strategy.target)
      @logger = Logger.new($stdout)
    end

    def create_order(order)
      @market_api.create_order(order)
    end
  end
end
