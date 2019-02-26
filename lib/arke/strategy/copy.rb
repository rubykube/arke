module Arke::Strategy
  # This class implements basic copy strategy behaviour
  # * aggreagates orders from sources
  # * push order to target
  class Copy < Base
    def initialize(config)
      super
    end

    # Processes orders and decides what action should be sent to @target
    def call
      # So, here we need access to workers, at least to target worker
      Arke::Log.debug 'Copy startegy called'
      action = Arke::Action.new(:echo_action, { 'hello' => 'world' })
      @target.push(action)
    end
  end
end
