require_relative 'worker'
require_relative 'websocket'
require 'action'
require 'log'

module Arke
  class Manager
    def initialize
      @workers = []
      @shutdown = false
    end

    def bootstrap(config)
      @strategy = Arke::Strategy.create(config)
      @rate_limit = config['target']['api_rate_limit']

      config['sources'].each do |source|
        exchange =  Arke::Exchange.create(source, @strategy)

        @workers.push(Arke::Worker.new(exchange))
      end
      # we need to give access to workers for strategy to send actions
      @workers.each { |w| @strategy.add_source_worker(w) }

      target = Arke::Exchange.create(config['target'], @strategy)
      target_worker = Arke::Worker.new(target)
      @workers.push(target_worker)

      # we need to share target worker with strategy as well
      @strategy.set_target_worker(target_worker)

      ####### WIP separate worker for websocket
      @websocket = Arke::Websocket.new(@workers.first)
      # in future we can subscribe worker, if we have
      # weboscket:
      #    url: ...
      # in config
      # @websocket.subscribe

      Thread.new { @websocket.run }
      ################

      run
    end

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
