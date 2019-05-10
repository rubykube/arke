require 'clamp'
require 'yaml'

require 'arke/command/root'
require 'arke'

module Arke
  module Command
    def run!
      load_configuration
      Arke::Log.define
      Root.run
    end
    module_function :run!

    def load_configuration
      config = YAML.load_file('config/strategy.yaml')

      Arke::Configuration.define { |c| c.strategy = config['strategy'] }
    end
    module_function :load_configuration

    # NOTE: we can add more features here (colored output, etc.)
  end
end
