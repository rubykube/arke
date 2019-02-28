require 'faraday'
require 'faraday_middleware'
require 'em-synchrony'
require 'em-synchrony/em-http'

require 'exchange'
require 'strategy'

module Arke
  # Main event ractor loop
  class Reactor

    # * @shutdown is a flag which controls strategy execution
    def initialize(config)
      @shutdown = false
      @strategy = Arke::Strategy.create(config)
      @dax = build_dax(config)
      @target = Arke::Exchange.create(config['target'])

      rate_limit = config['target']['rate_limit'] || 1.0
      rate_limit = 1.0 if rate_limit <= 0
      @min_delay = 1.0 / rate_limit
      trap('INT') { stop }
    end

    def build_dax(config)
      dax = {}
      config['sources'].each { |ex|
        dax[ex['driver'].to_sym] = Arke::Exchange.create(ex)
      }
      return dax
    end

    # * traps SIGINT
    # * strategy execution rate is limited by target's +rate_limit+
    def run
      EM.synchrony do
        @dax.each { |name, exchange|
          Arke::Log.debug "Starting Exchange: #{name}"
          exchange.start
        }

        @timer = EM::Synchrony::add_periodic_timer(@min_delay) do
          Arke::Log.debug "Calling Strategy #{Time.now}"
          @strategy.call(@target, @dax)
        end
      end
    end

    # Stops workers and strategy execution
    # * sets @shutdown flag to +true+
    # * broadcasts +:shutdown+ action to workers
    def stop
      puts 'Shutdown trading'
      @shutdown = true
      @timer.cancel
      EM.stop
    end
  end
end
