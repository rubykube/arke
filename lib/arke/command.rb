require 'clamp'
require 'command/root'
require 'configuration'
require 'log'
require 'yaml'

module Arke
  module Command
    def run!
      load_configuration
      Arke::Log.define
      Root.run
    end
    module_function :run!

    def load_configuration
      strategy = YAML.load_file('config/strategy.yaml')['strategy']

      Arke::Configuration.define do |config|
        config.min_update_period = strategy['min_update_period']
        config.strategy = strategy
        config.target = strategy['target']
        config.sources = strategy['sources']
      end
    end
    module_function :load_configuration

    # NOTE: we can add more features here (colored output, etc.)
  end
end
