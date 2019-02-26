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

    def to_s
      @workload.class.name
    end

    private

    def process
      loop do
        action = @queue.pop
        Arke::Log.debug "#{self}: Got action: #{action}"
        break if action.type == :shutdown
        @workload.call(action)
      end
      Arke::Log.debug "#{self}: Leaving worker"
    end
  end
end
