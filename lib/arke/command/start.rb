module Arke
  module Command
    class Start < Clamp::Command
      def execute
        config = Arke::Configuration.require!(:strategy)
        manager = Arke::Manager.new
        manager.bootstrap(config)
      end
    end
  end
end
