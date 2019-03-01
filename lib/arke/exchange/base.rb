module Arke::Exchange

  # Base class for all exchanges
  class Base
    attr_reader :queue, :min_delay
    attr_accessor :timer

    def initialize(opts)
      @market  = opts['market']
      @driver  = opts['driver']
      @api_key = opts['key']
      @secret  = opts['secret']
      @queue   = EM::Queue.new
      @timer   = nil

      rate_limit = opts['rate_limit'] || 1.0
      rate_limit = 1.0 if rate_limit <= 0
      @min_delay = 1.0 / rate_limit
    end
  end
end
