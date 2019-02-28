module Arke::Strategy

  # Base class for all strategies
  class Base
    def initialize(config)
      @config = config
    end
  end
end
