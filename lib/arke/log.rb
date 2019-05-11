require 'logger'

module Arke
  # Holds Arke apllication logger
  module Log
    class << self
      # Inits logger
      def define(output = STDOUT)
        @logger ||= Logger.new(output)
      end

      def logger
        @logger || define()
      end

      # Logs +INFO+ message
      def info(message)
        logger.info message
      end

      # Logs +FATAL+ message
      def fatal(message)
        logger.fatal message
      end

      # Logs +DEBUG+ message
      def debug(message)
        logger.debug message
      end

      # Logs +ERROR+ message
      def error(message)
        logger.error message
      end
    end
  end
end
