module Arke
  # This class represents Actions as jobs which are executed by Exchanges
  class Action
    attr_reader :type, :params, :destination

    # Takes type of action and params:
    # :shutdown:: +params+ - nil
    # :create_order:: +params+ - order
    # :cancel_order:: +params+ - order
    def initialize(type, destination, params=nil)
      @type        = type
      @params      = params
      @destination = destination
    end

    def to_s
      "#Type: #{@type}, params: #{@params}"
    end
  end
end
