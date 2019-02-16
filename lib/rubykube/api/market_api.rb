module Rubykube
  class MarketApi < ApiClient
    def initialize(params)
      super
    end

    def create_order(order)
      post(
        'peatio/market/orders',
        {
          market: order.market.downcase,
          side:   order.side.to_s,
          volume: order.amount,
          price:  order.price
        }
      )
    end

    private

    def get(path, params = nil)
      super
    end

    def post(path, params = nil)
      super
    end

  end
end
