module Arke
  module Command
    class Start < Clamp::Command
      def execute
        strategy = Arke.config.strategy.new
        strategy.start
      end
    end
  end
end
