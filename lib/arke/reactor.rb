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
      @target = Arke::Exchange.create(config['target'])
      @dax = build_dax(config)

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
      @queue = EM::Queue.new
      EM.synchrony do
        @dax.each { |name, exchange|
          Arke::Log.debug "Starting Exchange: #{name}"
          exchange.start
        }

        @timer = EM::Synchrony::add_periodic_timer(@min_delay) do
          Arke::Log.debug "Calling Strategy #{Time.now} - Queue size: #{@queue.size}"
          @strategy.call(@target, @dax) do |action|
            @queue.push(action)
          end
          @queue.pop { |action|
            Arke::Log.debug "pop: #{action}"
            schedule(action)
          }
        end
      end
    end

    def schedule(action)
      case action.type
      when :ping
        @target.ping
      when :order_create
      when :order_stop
      else
        Arke::Log.error "Unknown Action type: #{action.type}"
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
