require 'faraday'
require 'faraday_middleware'
require 'em-synchrony'
require 'em-synchrony/em-http'

require 'exchange/bitfinex'

module Arke
  # Main event ractor loop
  class Reactor

    # * @shutdown is a flag which controls strategy execution
    def initialize(config)
      @shutdown = false
    end

    # * traps SIGINT
    # * strategy execution rate is limited by target's +api_rate_limit+
    def run
      trap('INT') { stop }

      url = 'http://www.devkube.com/api/v2/barong/identity/ping'

      conn = Faraday.new(url: url) do |builder|
        builder.response :logger
        builder.response :json
        builder.adapter :em_synchrony
      end

      bf = Arke::Exchange::Bitfinex.new('ETHUSD')
      EM.synchrony do
        n=0
        bf.start
        timer = EM::Synchrony::add_periodic_timer(1) do
          puts "the time is #{Time.now}"
          timer.cancel if (n+=1) > 5
          response = conn.get
          pp response.body
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
