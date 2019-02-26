module Arke
  class Worker < Thread

    def initialize(job)
      @workload = job
      @queue = Queue.new
      super(&method(:process))
    end

    def push(action)
      @queue.push(action)
    end

    private

    def process
      loop do
        action = @queue.pop
        puts "Got action : #{action.type}"
        break if action.type == :shutdown
        @workload.call(action)
      end
      puts "Leaving worker"
    end
  end
end
