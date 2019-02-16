module Arke
  module Command
    class Start < Clamp::Command
      def execute
        Arke::Configuration.require!(:strategy).start
      end
    end
  end
end
