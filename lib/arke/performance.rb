require 'log'

module Arke
  module Performance
    class Unit
      def initialize(unit)
        @unit = unit
        @timestamp = Time.now
        @counter = 0
      end

      def increment
        @counter += 1
      end

      def report(caller_timestamp)
        delta_time = caller_timestamp - @timestamp
        Arke::Log.info("#{@unit.upcase}: Time elapsed: #{delta_time}")
        Arke::Log.info("#{@unit.upcase} processed in total: #{@counter}")
        Arke::Log.info("Speed: #{@counter / delta_time} #{@unit} per second")
      end
    end

    class << self
      def add_unit(key, unit = 'units')
        @units ||= {}

        @units[key] = Unit.new(unit) unless @units[key]
      end

      def accept_unit(key)
        @units[key].increment
      end

      def report
        return unless @units

        called_at = Time.now
        Arke::Log.info('### Performance report: ')

        @units.each do |_, unit|
          unit.report(called_at)
        end
      end
    end
  end
end
