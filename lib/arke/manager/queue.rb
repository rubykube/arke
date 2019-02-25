# duplicates standard Queue, if we will not add custom logic here,
# can be deleted

module Arke
  class ActionQueue
    def initialize
      @queue = Queue.new
    end

    def pop
      @queue.pop
    end

    def push(action)
      @queue.push(action)
    end
  end
end
