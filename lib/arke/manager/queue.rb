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
