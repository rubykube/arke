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
        config.pair = strategy['pair']
        config.target = strategy['target']
        config.target['driver'] = Arke::Exchange.exchange_class(config.target['driver'])
        config.strategy = Arke::Strategy.create(strategy)

        config.sources = strategy['sources'].collect do |source|
          source['driver'] = Arke::Exchange.exchange_class(source['driver'])

          source
        end
      end
    end
    module_function :load_configuration

    # NOTE: we can add more features here (colored output, etc.)
  end
end
