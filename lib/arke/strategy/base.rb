module Arke::Strategy

  # Base class for all strategies
  class Base
    def initialize(config)
      @config = config
      @volume_scaler = config['volume_scaler']
      @spread = config['spread']
    end
  end
end
