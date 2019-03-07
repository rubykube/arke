module Arke::Strategy

  # Base class for all strategies
  class Base
    def initialize(config)
      @config = config
      @volume_ratio = config['volume_ratio']
      @spread = config['spread']
    end
  end
end
