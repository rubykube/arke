# frozen_string_literal: true

module Arke::Exchange
  class Bitfinex < Base

    def initialize
      super
    end

    def start
      super.run do
      end
    end

    def run
      raise RunNotOverriden
    end
  end
end
