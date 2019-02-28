module Arke
  module Command
    class Start < Clamp::Command
      def execute
        config = Arke::Configuration.require!(:strategy)
        reactor = Arke::Reactor.new(config)
        reactor.run
      end
    end
  end
end
