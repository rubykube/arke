require_relative 'worker'
require 'action'

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

      @strategy.set_target_worker(target_worker)

      run
    end

    def run
      trap('INT') { stop }

      @workers.each(&:run)

      until @shutdown do
        timestamp = Time.now

        @strategy.call

        delay = @rate_limit - (Time.now - timestamp)
        sleep(delay) if delay > 0
      end
    end

    def stop
      puts 'Shutting down'
      shutdown_action = Arke::Action.new(:shutdown, nil)
      @shutdown = true
      @workers.each do |worker|
        worker.send_action(shutdown_action)
        # worker.lock -> we can lock worker's queue to disable new actions
        worker.join
      end
    end
  end
end
