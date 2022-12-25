# See Pagy::Countless API documentation: https://ddnexus.github.io/pagy/docs/api/calendar
# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/time'
require 'active_support/core_ext/date_and_time/calculations'
require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/integer/time'

require 'pagy'

class Pagy # :nodoc:
  # Base class for time units subclasses (Year, Quarter, Month, Week, Day)
  class Calendar < Pagy
    # Specific out of range error
    class OutOfRangeError < StandardError; end

    # List of units in desc order of duration. It can be used for custom units.
    UNITS = %i[year quarter month week day]  # rubocop:disable Style/MutableConstant

    attr_reader :order

    # Merge and validate the options, do some simple arithmetic and set a few instance variables
    def initialize(vars) # rubocop:disable Lint/MissingSuper
      raise InternalError, 'Pagy::Calendar is a base class; use one of its subclasses' if instance_of?(Pagy::Calendar)

      vars = self.class::DEFAULT.merge(vars)  # subclass specific default
      normalize_vars(vars)                    # general default
      setup_vars(page: 1)
      setup_unit_vars
      setup_params_var
      raise OverflowError.new(self, :page, "in 1..#{@last}", @page) if @page > @last

      @prev = (@page - 1 unless @page == 1)
      @next = @page == @last ? (1 if @vars[:cycle]) : @page + 1
    end

    # The label for the current page (it can pass along the I18n gem opts when it's used with the i18n extra)
    def label(opts = {})
      label_for(@page, opts)
    end

    # The label for any page (it can pass along the I18n gem opts when it's used with the i18n extra)
    def label_for(page, opts = {})
      opts[:format] ||= @vars[:format]
      localize(starting_time_for(page.to_i), opts)  # page could be a string
    end

    protected

    # The page that includes time
    def page_at(time)
      raise OutOfRangeError unless time.between?(@initial, @final)

      offset = page_offset_at(time)   # offset starts from 0
      @order == :asc ? offset + 1 : @pages - offset
    end

    # Base class method for the setup of the unit variables (subclasses must implement it and call super)
    def setup_unit_vars
      raise VariableError.new(self, :format, 'to be a strftime format', @vars[:format]) unless @vars[:format].is_a?(String)
      raise VariableError.new(self, :order, 'to be in [:asc, :desc]', @order) \
            unless %i[asc desc].include?(@order = @vars[:order])

      @starting, @ending = @vars[:period]
      raise VariableError.new(self, :period, 'to be a an Array of min and max TimeWithZone instances', @vars[:period]) \
            unless @starting.is_a?(ActiveSupport::TimeWithZone) \
                && @ending.is_a?(ActiveSupport::TimeWithZone) && @starting <= @ending
    end

    # Apply the strftime format to the time (overridden by the i18n extra when localization is required)
    def localize(time, opts)
      time.strftime(opts[:format])
    end

    # Number of time units to offset from the @initial time, in order to get the ordered starting time for the page.
    # Used in starting_time_for(page) where page starts from 1 (e.g. page to starting_time means subtracting 1)
    def time_offset_for(page)
      @order == :asc ? page - 1 : @pages - page
    end

    # Period of the active page (used internally for nested units)
    def active_period
      [[@starting, @from].max, [@to - 1, @ending].min] # -1 sec: include only last unit day
    end

    class << self
      # Create a subclass instance by unit name (internal use)
      def create(unit, vars)
        raise InternalError, "unit must be in #{UNITS.inspect}; got #{unit}" unless UNITS.include?(unit)

        name    = unit.to_s
        name[0] = name[0].capitalize
        Object.const_get("Pagy::Calendar::#{name}").new(vars)
      end
    end
  end
  # Require the subclass files in UNITS (no custom unit at this point yet)
  Calendar::UNITS.each { |unit| require "pagy/calendar/#{unit}" }
end
