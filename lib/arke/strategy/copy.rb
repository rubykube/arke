module Arke::Strategy
  # This class implements basic copy strategy behaviour
  # * aggreagates orders from sources
  # * push order to target
  class Copy
    def initialize(config)
    end

    # Processes orders and decides what action should be sent to @target
    def execute
      # So, here we need access to workers, at least to target worker
      Arke::Log.debug 'Copy startegy called'

      Arke::Action.new(:echo_action, { 'hello' => 'world' })
    end
  end
end
