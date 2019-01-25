module Arke
  module Command
    class Version < Clamp::Command
      def execute
        puts "Arke version #{read_version}"
      end

      def read_version
        File.read(File.expand_path('../../../VERSION', __dir__))
      end
    end
  end
end
