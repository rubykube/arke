module Arke
  class Order

    attr_reader :market, :price, :amount, :side

    def initialize(market, price, amount, side)
      @market = market
      @price = price
      @amount = amount
      @side = side
    end

    def to_s
      "#{@market}: #{@side} #{@price} x #{@amount}"
    end
  end
end
