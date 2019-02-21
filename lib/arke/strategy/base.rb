require 'exchange'

module Arke::Strategy
  class Base
    RunNotOverriden = Class.new(StandardError)

    def initialize
      @shutdown = false
      # we limit strategy update rate here (seconds)
      # easy to change if we will implement some stress-testing strategies
      @minimum_update_period = Arke::Configuration.get(:min_update_period) || 1.0
    end

    def start
      sources = Arke::Configuration.require!(:sources).collect do |source|
        Arke::Exchange.create(source['driver'], self)
      end

      target = Arke::Exchange.create(Arke::Configuration.require!(:target)['driver'], self)

      @threads = sources.collect { |source| Thread.new {source.start } }
      @threads.push(Thread.new { target.start })

      trap('SIGINT') { stop }

      on_start

      run_loop
    rescue StandardError => e
      Arke::Log.fatal e
      exit
    end

    def run_loop
      until @shutdown do
        timestamp = Time.now

        run

        delta = @minimum_update_period - (Time.now - timestamp)
        sleep(delta) if delta > 0
      end
    end

    def stop
      on_stop
      @shutdown = true

      @threads.each { |thread| thread.join }
      on_exit
    end

    def shutdown?
      @shutdown
    end

    #methods to override
    def on_start
    end

    def run
      raise RunNotOverriden.new
    end

    def on_stop
    end

    def on_exit
    end
  end
end
