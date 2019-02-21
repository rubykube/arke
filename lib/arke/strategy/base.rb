# frozen_string_literal: true

module Arke::Strategy
  class Base
    attr_accessor :event_queue

    def initialize
      @event_queue = Queue.new
    end

    def start
      Thread.new do
        yield
      end
    end
  end
end
