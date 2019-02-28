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
      trap('INT') { stop }

      url = 'http://www.devkube.com/api/v2/barong/identity/ping'

      conn = Faraday.new(url: url) do |builder|
        builder.response :logger
        builder.response :json
        builder.adapter :em_synchrony
      end

      # bf = Arke::Exchange::Bitfinex.new('ETHUSD')
      EM.synchrony do
        @dax.each { |name, exchange|
          Arke::Log.debug "Starting Exchange: #{name}"
          exchange.start
        }

        timer = EM::Synchrony::add_periodic_timer(@min_delay) do
          Arke::Log.debug "Calling Strategy #{Time.now}"
          timer.cancel if @shutdown
          pp @dax[:bitfinex].orderbook
          response = conn.get
        end
      end
    end

    # Stops workers and strategy execution
    # * sets @shutdown flag to +true+
    # * broadcasts +:shutdown+ action to workers
    def stop
      @shutdown = true
      EM.stop
    end
  end
end
