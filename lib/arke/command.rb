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
    end
    module_function :load_configuration

    # NOTE: we can add more features here (colored output, etc.)
  end
end
