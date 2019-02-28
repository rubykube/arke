module Arke::Strategy
  # This class implements basic copy strategy behaviour
  # * aggreagates orders from sources
  # * push order to target
  class Copy < Base

    # Processes orders and decides what action should be sent to @target
    def call(target, dax)
      # Arke::Action.new(:echo_action, { 'hello' => 'world' })
      Arke::Log.debug 'Copy startegy called'
      puts dax[:bitfaker].print
      response = target.ping
    end
  end
end
