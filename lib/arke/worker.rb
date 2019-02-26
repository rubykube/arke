module Arke
  # This class holds Arke::Exchange runtime logic
  # * receives +Arke::Actions+ and stores them in @queue
  # * calls @workload(Arke::Exchange instance) to execute action in an process
  class Worker < Thread
    # Takes +executor+ - Arke::Exchange instance
    # * sets @executor variable
    # * inirialize @action_queue
    def initialize(job)
      @workload = job
      @queue = Queue.new
      super(&method(:process))
    end

    # Takes +action+ and pushes it to @action_queue
    def push(action)
      @queue.push(action)
    end

    def to_s
      @workload.class.name
    end

    private
    # Main execution loop
    # * pops +action+ from @action_queue
    # * calls +Arke::Exchange+ to execute action
    # * stops if :shutdown action received
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
