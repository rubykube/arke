# encoding: UTF-8
# frozen_string_literal: true

module Arke
  class Order

    attr :id, :market, :price, :amount, :side, :state

    def initialize(id, market, price, amount)
      @id = id
      @market = market
      @price = price
      @amount = amount
      @side = :buy
      @state = :new
      if amount < 0
        @amount = amount * -1
        @side = :sell
      end
    end

    def to_s
      "#{@market}: #{@side} #{@price} x #{@amount}"
    end

    def to_json
      [@id, @market, @price, @amount, @side, @state].to_json
    end

  end
end
