module RubykubeApi
  class MarketApi < ApiClient
    def initialize(params)
      super
    end

    def create_order(order)
      Arke::Performance.elapse(:create_order) do
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
