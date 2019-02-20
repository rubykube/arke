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
        Arke::Log.info("Unit #{@unit.upcase}: Time elapsed: #{delta_time}")
        Arke::Log.info("#{@unit.upcase} processed in total: #{@counter}")
        Arke::Log.info("Speed: #{@counter / delta_time} #{@unit} per second")
      end
    end

    class Elapser
      def initialize(key)
        @key = key
        @counter = 0
        @min = nil
        @max = 0
        @total_elapsed = 0
      end

      def record(elapsed_time)
        @counter += 1
        @total_elapsed += elapsed_time

        if @min.nil?
          @min = elapsed_time
        else
          @min = (@min > elapsed_time)? elapsed_time : @min
        end

        @max = (@max < elapsed_time)? elapsed_time : @max
      end

      def report
        Arke::Log.info("Report for #{@key.to_s.upcase} Elapser")
        Arke::Log.info("Total elapsed: #{@total_elapsed}, called: #{@counter} times")
        Arke::Log.info("AVG: #{@total_elapsed / @counter} MIN: #{@min} MAX: #{@max} seconds")
      end
    end

    class << self
      def elapse(key)
        @elapsers ||= {}
        @elapsers[key] ||= Elapser.new(key)

        elapser = @elapsers[key]
        timestamp = Time.now
        yield
        elapser.record(Time.new - timestamp)
      end

      def add_unit(key, unit = 'units')
        @units ||= {}

        @units[key] = Unit.new(unit) unless @units[key]
      end

      def accept_unit(key)
        @units[key].increment
      end

      def report()
        return if @units.nil? && @elapsers.nil?

        called_at = Time.now

        Arke::Log.info('###')
        Arke::Log.info('### Performance report: ')

        @units.each { |_, unit| unit.report(called_at) } unless @units.nil?
        @elapsers.each { |_, elaps| elaps.report } unless @elapsers.nil?
      end
    end
  end
end
