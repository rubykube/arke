require 'clamp'
require 'arke/command/root'

module Arke
  module Command
    def run!
      Root.run
    end
    module_function :run!

    # NOTE: we can add more features here (colored output, etc.)
  end
end
