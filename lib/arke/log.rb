require 'logger'

module Arke
  module Log
    class << self
      def define
        @logger ||= Logger.new($stderr)
      end

      def info(message)
        @logger.info message
      end

      def fatal(message)
        @logger.fatal message
      end
    end
  end
end
