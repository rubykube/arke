module Arke
  module Command
    class Start < Clamp::Command
      def execute
        config = Arke::Configuration.require!(:strategy)
        Arke::Strategy.create(config['type']).start
      end
    end
  end
end
