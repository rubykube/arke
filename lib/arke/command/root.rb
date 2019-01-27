require 'command/start'
require 'command/version'

module Arke
  module Command
    class Root < Clamp::Command
      subcommand 'start', 'Starting the bot', Start
      subcommand 'version', 'Print the Arke version', Version
    end
  end
end
