module Arke
  class Action
    attr_reader :type, :params

    def initialize(type, params=nil)
      @type   = type
      @params = params
    end

    def to_s
      "#Type: #{@type}, params: #{@params}"
    end
  end
end
