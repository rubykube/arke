require 'arke/command/version'

module Arke
  module Command
    class Root < Clamp::Command
      subcommand 'version', 'Print the Arke version', Version
    end
  end
end
