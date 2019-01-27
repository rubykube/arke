require 'exchange/bitfinex'

module Arke
  module Command
    class Start < Clamp::Command
      def execute
        bf = Arke::Exchange::Bitfinex.new
        bf.start
      end
    end
  end
end
