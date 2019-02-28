require_relative 'worker'
require_relative 'websocket'
require 'action'
require 'log'

module Arke
  # This class holds thread (Arke::Worker) creation and shutdown logic
  class Manager
    # * @workers is collection of running threads
    # * @shutdown is a flag which controls strategy execution
    def initialize
      @workers = []
      @shutdown = false
    end

    # Inits resources and run Arke::Workers
    # Takes +config+ - hash with a strategy configuration
    # * inits +Arke::Strategy+ instance
    # * inits +Arke::Exchange+ instances
    # * sets +target_worker+ for @strategy (target exchange)
    # * run +Arke::Workers+
    def bootstrap(config)
      @strategy = Arke::Strategy.create(config)
      @rate_limit = config['target']['api_rate_limit']

      config['sources'].each do |source|
        exchange =  Arke::Exchange.create(source, @strategy)

        @workers.push(Arke::Worker.new(exchange))
      end
      @workers.each { |w| @strategy.add_source_worker(w) }

      target = Arke::Exchange.create(config['target'], @strategy)
      target_worker = Arke::Worker.new(target)
      @workers.push(target_worker)

      @strategy.set_target_worker(target_worker)

      @websocket = Arke::Websocket.new(@workers.first)

      Thread.new { @websocket.run }

      run
    end

    # Starts workers and strategy
    # * traps SIGINT
    # * strategy execution rate is limited by target's +api_rate_limit+
    def run
      trap('INT') { stop }

      #@workers.each(&:run)

      loop do
        if @shutdown
          Arke::Log.debug 'Stopping Strategy'
          break
        end
        timestamp = Time.now

        @strategy.call

        delay = @rate_limit - (Time.now - timestamp)
        sleep(delay) if delay > 0
      end
    end

    # Stops workers and strategy execution
    # * sets @shutdown flag to +true+
    # * broadcasts +:shutdown+ action to workers
    def stop
      shutdown_action = Arke::Action.new(:shutdown, nil)
      @shutdown = true
      @workers.each do |worker|
        worker.push(shutdown_action)
        # worker.lock -> we can lock worker's queue to disable new actions
        worker.join
      end
    end
  end
end
