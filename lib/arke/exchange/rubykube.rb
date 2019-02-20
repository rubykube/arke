require 'rubykube_api/api/market_api'

module Arke::Exchange
  class Rubykube < Base
    def initialize(strategy)
      super
      @market_api = RubykubeApi::MarketApi.new(Arke::Configuration.require!(:target))
    end

    def call(action)
      if action.type == :create_order
        @market_api.create_order(action.params)
      elsif action.type == :cancel_order
        @market_api.cancel_order(action.params)
      end
    end
  end
end
