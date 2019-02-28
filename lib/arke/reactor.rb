require 'faraday'
require 'faraday_middleware'
require 'em-synchrony'
require 'em-synchrony/em-http'

require 'exchange'
require 'strategy'
require 'exchange/bitfinex'
require 'exchange/rubykube'
require 'order' # FOR TEST

module Arke
  # Main event ractor loop
  class Reactor

    # * @shutdown is a flag which controls strategy execution
    def initialize(config)
      @shutdown = false
      @strategy = Arke::Strategy.create(config)
      @sources = config['sources'].map { |source| Arke::Exchange.create_ws(source, config['pair']) }
      @target = Arke::Exchange.create(config['target'])
      @api_rate_limit = config['target']['api_rate_limit']
    end

    # * traps SIGINT
    # * strategy execution rate is limited by target's +api_rate_limit+
    def run
      trap('INT') { stop }

      conn = Faraday.new(url: "#{@target.host}/api/v2") do |builder|
        builder.response :logger
        builder.response :json
        builder.adapter :em_synchrony
      end

      EM.synchrony do
        @sources.each(&:start)

        timer = EM::Synchrony::add_periodic_timer(@api_rate_limit) do
          puts "the time is #{Time.now}"
          timer.cancel if @shutdown
          response = @target.create_order(conn, Arke::Order.new(99999999, 'ethusd', 1, 10))
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
