require 'pry'

require 'arke/strategy'
require 'swagger_client'

module Arke
  module Command
    class Console < Clamp::Command
      include SwaggerClient

      def execute
        Pry.hooks.add_hook(:before_session, 'arke_load') do |output, binding, pry|
          output.puts("Arke development console")
        end

        # binding.pry
        Pry.start
      end
    end
  end
end
