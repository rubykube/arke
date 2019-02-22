require_relative 'queue'

module Arke
  class Worker
    def initialize(executor)
      @executor = executor
      @action_queue = Arke::ActionQueue.new
    end

    def run
      @thread = Thread.new { action_loop }
    end

    def join
      @thread.join
    end

    def send_action(action)
      @action_queue.push(action)
    end

    def action_loop
      loop do
        action = @action_queue.pop
        @executor.call(action)

        return if action.type == :shutdown
      end
    end
  end
end
