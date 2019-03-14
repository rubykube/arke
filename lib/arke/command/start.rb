module Arke
  module Command
    class Start < Clamp::Command

      option "--dry", :flag, "dry run on the target"

      def execute
        config = Arke::Configuration.require!(:strategy)
        config['dry'] = dry?
        config['target']['driver'] = 'bitfaker' if dry?
        reactor = Arke::Reactor.new(config)
        reactor.run
      end
    end
  end
end
