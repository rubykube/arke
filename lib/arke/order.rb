# encoding: UTF-8
# frozen_string_literal: true

module Arke
  class Order

    attr :id, :market, :price, :amount, :side

    def initialize(id, market, price, amount)
      @id = id
      @market = market
      @price = price
      @amount = amount
      @side = :sell
      if amount < 0
        @amount = amount * -1
        @side = :buy
      end
    end

  end
end
