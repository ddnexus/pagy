# See Pagy::Countless API documentation: https://ddnexus.github.io/pagy/docs/api/calendar
# frozen_string_literal: true

require_relative '../pagy'
require_relative 'calendar/unit'

class Pagy # :nodoc:
  # Calendar class
  class Calendar < Hash
    # Specific out of range error
    class OutOfRangeError < VariableError; end

    # List of units in desc order of duration. It can be used for custom units.
    UNITS = %i[year quarter month week day]  # rubocop:disable Style/MutableConstant

    class << self
      private

      # Create a unit subclass instance by using the unit name (internal use)
      def create(unit, **vars)
        raise InternalError, "unit must be in #{UNITS.inspect}; got #{unit}" unless UNITS.include?(unit)

        name    = unit.to_s
        name[0] = name[0].capitalize
        Object.const_get("Pagy::Calendar::#{name}").new(**vars)
      end

      # Return calendar, from, to
      def init(conf, period, params)
        new.send(:init, conf, period, params)
      end
    end

    # Return the current time of the smallest time unit shown
    def showtime
      self[@units.last].from
    end

    private

    # Create the calendar
    def init(conf, period, params)
      @conf  = Marshal.load(Marshal.dump(conf))  # store a copy
      @units = Calendar::UNITS & @conf.keys # get the units in time length desc order
      raise ArgumentError, 'no calendar unit found in pagy_calendar @configuration' if @units.empty?

      @period     = period
      @params     = params
      @page_param = conf[:pagy][:page_param] || DEFAULT[:page_param]
      @units.each do |unit|  # set all the :page_param vars for later deletion
        unit_page_param         = :"#{unit}_#{@page_param}"
        conf[unit][:page_param] = unit_page_param
        conf[unit][:page]       = @params[unit_page_param]
      end
      calendar = {}
      object   = nil
      @units.each_with_index do |unit, index|
        params_to_delete    = @units[(index + 1), @units.size].map { |sub| conf[sub][:page_param] } + [@page_param]
        conf[unit][:params] = lambda { |up| up.except(*params_to_delete.map(&:to_s)) } # rubocop:disable Style/Lambda
        conf[unit][:period] = object&.send(:active_period) || @period
        calendar[unit]      = object = Calendar.send(:create, unit, **conf[unit])
      end
      [replace(calendar), object.from, object.to]
    end

    # Return the calendar object at time
    def calendar_at(time, **opts)
      conf        = Marshal.load(Marshal.dump(@conf))
      page_params = {}
      @units.inject(nil) do |object, unit|
        conf[unit][:period] = object&.send(:active_period) || @period
        conf[unit][:page]   = page_params[:"#{unit}_#{@page_param}"] \
                            = Calendar.send(:create, unit, **conf[unit]).send(:page_at, time, **opts)
        conf[unit][:params] ||= {}
        conf[unit][:params].merge!(page_params)
        Calendar.send(:create, unit, **conf[unit])
      end
    end
  end
  # Require the subclass files in UNITS (no custom unit at this point yet)
  Calendar::UNITS.each { |unit| require "pagy/calendar/#{unit}" }
end
