module Arke
  class Order

    attr :id, :market, :price, :amount, :side

    def initialize(id, market, price, amount)
      @id = id
      @market = market
      @price = price
      @amount = amount
      @side = :buy
      if amount < 0
        @amount = amount * -1
        @side = :sell
      end
    end

    def to_s
      "#{@market}: #{@side} #{@price} x #{@amount}"
    end

  end
end
