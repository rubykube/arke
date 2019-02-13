require 'clamp'
require 'command/root'
require 'configuration'

module Arke
  module Command
    def run!
      load_configuration
      Root.run
    end
    module_function :run!

    def load_configuration
      configs = YAML.load(File.open('config/variables.yaml'))
      Arke.configure do |config|
        config.host = configs['host']
        config.api_key = configs['api_key']
      end
    end
    module_function :load_configuration

    # NOTE: we can add more features here (colored output, etc.)
  end
end
