module Arke
  module Command
    class Start < Clamp::Command
      def execute
        # TODO: use configs
        strategy = Arke::Strategy::Copy.new
        strategy.start
      end
    end
  end
end
