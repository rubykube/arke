module Arke
  module Command
    class Start < Clamp::Command
      def execute
        Arke.config.strategy.start
      end
    end
  end
end
