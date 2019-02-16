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

      strategies = {
        'copy' => Arke::Strategy::Copy,
      }

      Arke.configure do |config|
        config.target = strategy['target']
        config.target['driver'] = drivers[config.target['driver']]
        config.strategy = strategies[strategy['type']]

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
