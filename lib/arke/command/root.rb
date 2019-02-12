require 'command/start'
require 'command/console'
require 'command/version'

module Arke
  module Command
    class Root < Clamp::Command
      subcommand 'start', 'Starting the bot', Start
      subcommand 'console', 'Start a development console', Console
      subcommand 'version', 'Print the Arke version', Version
    end
  end
end
