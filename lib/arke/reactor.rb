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
        @dax.each do |name, exchange|
          Arke::Log.debug "Starting Exchange: #{name}"

          exchange.timer = EM::Synchrony::add_periodic_timer(@target.min_delay) do
            Arke::Log.debug "Scheduling Action #{Time.now} - Exchange #{name} - Queue size: #{exchange.queue.size}"
            exchange.queue.pop do |action|
              Arke::Log.debug "pop: #{action}"
              schedule(action)
            end
          end

          exchange.start
        end

        @timer = EM::Synchrony::add_periodic_timer(@target.min_delay) do
          Arke::Log.debug "Calling Strategy #{Time.now}"
          @strategy.call(@target, @dax) do |action|
            @dax[action.destination].queue.push(action)
          end
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
      @dax.each { |name, exchange| exchange.timer.cancel }
      EM.stop
    end
  end
end
