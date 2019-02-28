module Arke
  class Order

    attr_reader :id, :market, :price, :amount, :side

    def initialize(id, market, price, amount, side)
      @id = id
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
