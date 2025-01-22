# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/time'
require 'active_support/core_ext/date_and_time/calculations'
require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/integer/time'

class Pagy
  class Offset
    # Calendar class
    class Calendar < Hash
      path = ROOT.join('lib/pagy/offset/calendar').freeze
      autoload :Unit,    path.join('unit')
      autoload :Day,     path.join('day')
      autoload :Week,    path.join('week')
      autoload :Month,   path.join('month')
      autoload :Quarter, path.join('quarter')
      autoload :Year,    path.join('year')

      # Specific out of range error
      class OutOfRangeError < VariableError; end

      # List of units in desc order of duration. It can be used for custom units.
      UNITS = %i[year quarter month week day]  # rubocop:disable Style/MutableConstant

      class << self
        private

        # Create a unit subclass instance by using the unit name (internal use)
        def create(unit, **vars)
          raise InternalError, "unit must be in #{UNITS.inspect}; got #{unit}" unless UNITS.include?(unit)

          name    = +unit.to_s
          name[0] = name[0].capitalize
          Object.const_get("Pagy::Offset::Calendar::#{name}").new(**vars)
        end

        # Return calendar, from, to
        def init(...)
          new.send(:init, ...)
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

        @period   = period
        @params   = params
        @page_sym = conf[:pagy][:page_sym] || Pagy::DEFAULT[:page_sym]
        # set all the :page_sym vars for later deletion
        @units.each { |unit| conf[unit][:page_sym] = :"#{unit}_#{@page_sym}" }
        calendar = {}
        object   = nil
        @units.each_with_index do |unit, index|
          params_to_delete    = @units[(index + 1), @units.size].map { |sub| conf[sub][:page_sym] } + [@page_sym]
          conf[unit][:params] = ->(up) { up.except!(*params_to_delete.map(&:to_s)) }
          conf[unit][:period] = object&.send(:active_period) || @period
          conf[unit][:page]   = @params[:"#{unit}_#{@page_sym}"] # requested page
          # :nocov:
          # simplecov doesn't need to fail block_given?
          conf[unit][:counts] = yield(unit, conf[unit][:period]) if block_given?
          # :nocov:
          calendar[unit] = object = Calendar.send(:create, unit, **conf[unit])
        end
        [replace(calendar), object.from, object.to]
      end

      # Return the calendar object at time
      def calendar_at(time, **opts)
        conf      = Marshal.load(Marshal.dump(@conf))
        page_syms = {}
        @units.inject(nil) do |object, unit|
          conf[unit][:period] = object&.send(:active_period) || @period
          conf[unit][:page]   = page_syms[:"#{unit}_#{@page_sym}"] \
                              = Calendar.send(:create, unit, **conf[unit]).send(:page_at, time, **opts)
          conf[unit][:params] ||= {}
          conf[unit][:params].merge!(page_syms)
          Calendar.send(:create, unit, **conf[unit])
        end
      end
    end
  end
end

# Require the subclass files in UNITS (no custom unit at this point yet)
# Pagy::Offset::Calendar::UNITS.each { |unit| require "pagy/offset/calendar/#{unit}" }
