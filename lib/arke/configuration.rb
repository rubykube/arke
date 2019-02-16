module Arke
  module Configuration
    PropertyNotSetError = Class.new(StandardError)

    class << self
      def define
        @config ||= OpenStruct.new
        yield(@config)
      end

      def get(key)
        @config ||= OpenStruct.new
        @config[key]
      end

      def require!(key)
        get(key) || (raise PropertyNotSetError.new)
      end
    end
  end
end
