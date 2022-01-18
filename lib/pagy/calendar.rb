# See Pagy::Countless API documentation: https://ddnexus.github.io/pagy/api/calendar
# frozen_string_literal: true

require 'pagy'

class Pagy # :nodoc:
  # Base class for time units subclasses (Year, Quarter, Month, Week, Day)
  class Calendar < Pagy
    # List of units in desc order of duration. It can be used for custom units.
    UNITS = %i[year quarter month week day]  # rubocop:disable Style/MutableConstant
    DAY   = 60 * 60 * 24  # One day in seconds
    WEEK  = DAY * 7       # One week in seconds

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
      local = @in_time_zone.call(starting_time_for(page.to_i))
      localize(local, opts)  # page could be a string
    end

    protected

    # Base class method for the setup of the unit variables (subclasses must implement it and call super)
    def setup_unit_vars
      raise VariableError.new(self, :format, 'to be a strftime format', @vars[:format]) unless @vars[:format].is_a?(String)
      raise VariableError.new(self, :order, 'to be in [:asc, :desc]', @order) \
            unless %i[asc desc].include?(@order = @vars[:order])

      @starting, @ending = @vars[:period]
      @in_time_zone      = @vars[:in_time_zone]
      return deprecated_setup_unit_vars unless @in_time_zone.is_a?(Proc)  # remove in 6.0
      raise VariableError.new(self, :in_time_zone, 'to be a proc', @in_time_zone) unless @in_time_zone.is_a?(Proc)
      raise VariableError.new(self, :period, 'to be a an Array of min and max UTC Time instances', @vars[:period]) \
          unless @starting.is_a?(Time) && @ending.is_a?(Time) && @starting.utc? && @ending.utc? && @starting <= @ending
    end

    # Deprecated way of passing period as local time
    def deprecated_setup_unit_vars  # remove in 6.0
      Warning.warn '[PAGY WARNING] You must set the :in_time_zone Proc variable for accurate calculation and labelling! ' \
                   'See https://github.com/ddnexus/pagy/blob/master/CHANGELOG.md#deprecations'
      @in_time_zone = ->(time) { time }
      raise VariableError.new(self, :period, 'to be a an Array of min and max local Time instances', @vars[:period]) \
            unless @starting.is_a?(Time) && @ending.is_a?(Time) && !@starting.utc? && !@ending.utc? && @starting <= @ending \
                   && (@utc_offset = @starting.utc_offset) == @ending.utc_offset
    end

    # Apply the strftime format to the time (overridden by the i18n extra when localization is required)
    def localize(time, opts)
      time.strftime(opts[:format])
    end

    # Number of units to offset from the @initial time, in order to get the ordered starting time for the page.
    # Used in starting_time_for(page) with a logic equivalent to: @initial + (offset_units_for(page) * unit_time_length)
    def offset_units_for(page)
      @order == :asc ? page - 1 : @pages - page
    end

    # Create a new local time at the beginning of the day
    def new_time(year, month = 1, day = 1)
      # remove condition in 6.0
      @utc_offset ? Time.new(year, month, day, 0, 0, 0, @utc_offset) : Time.utc(year, month, day, 0, 0, 0)
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
