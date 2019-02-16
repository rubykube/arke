require 'clamp'
require 'command/root'
require 'configuration'
require 'yaml'

module Arke
  module Command
    def run!
      load_configuration
      Root.run
    end
    module_function :run!

    def load_configuration
      strategy = YAML.load_file('config/strategy.yaml')['strategy']

      drivers = {
        'bitfinex' => Arke::Exchange::Bitfinex,
        'rubykube' => Rubykube::MarketApi,
      }

      Arke::Configuration.define do |config|
        config.strategy = Arke::Strategy.create(strategy)

        config.target = strategy['target']
        config.target['driver'] = drivers[config.target['driver']]

        config.sources = strategy['sources'].collect do |source|
          source['driver'] = drivers[source['driver']]

          source
        end
      end
    end
    module_function :load_configuration

    # NOTE: we can add more features here (colored output, etc.)
  end
end
