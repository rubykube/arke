require 'performance'

module Arke
  module Command
    class Start < Clamp::Command
      def execute
        Arke::Configuration.require!(:strategy).start
        Arke::Performance.report
      end
    end
  end
end
