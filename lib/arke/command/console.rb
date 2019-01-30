require 'pry-byebug'

require 'arke/strategy'
require 'arke/strategy/copy'
require 'swagger_client'

module Arke
  module Command
    class Console < Clamp::Command
      def execute
        Arke.module_exec do
          binding.pry
        end
      end
    end
  end
end
