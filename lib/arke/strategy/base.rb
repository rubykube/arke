require 'exchange'

module Arke::Strategy
  class Base
    def initialize
      @shutdown = false
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

      until @shutdown do
        run
      end

      @threads.each { |thread| thread.join }
      on_exit
    end

    def stop
      on_stop
      @shutdown = true
    end

    def shutdown?
      @shutdown
    end

    #methods to override
    def on_start
    end

    def run
    end

    def on_stop
    end

    def on_exit
    end
  end
end
