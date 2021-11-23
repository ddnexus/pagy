# See Pagy::Countless API documentation: https://ddnexus.github.io/pagy/api/calendar
# frozen_string_literal: true

require 'pagy'

class Pagy # :nodoc:
  # Base class for time units subclasses (Year, Month, Week, Day)
  class Calendar < Pagy
    DAY  = 60 * 60 * 24
    WEEK = DAY * 7

    attr_reader :order

    # Merge and validate the options, do some simple arithmetic and set a few instance variables
    def initialize(vars) # rubocop:disable Lint/MissingSuper
      raise InternalError, 'Pagy::Calendar is a base class; use one of its subclasses' if instance_of?(Pagy::Calendar)

      normalize_vars(vars)
      @vars = self.class::DEFAULT.merge(@vars)
      setup_vars(page: 1)
      setup_unit_vars
      setup_params_var
      raise OverflowError.new(self, :page, "in 1..#{@last}", @page) if @page > @last

      @prev = (@page - 1 unless @page == 1)
      @next = @page == @last ? (1 if @vars[:cycle]) : @page + 1
    end

    # The label for the current page (it can pass along the I18n gem opts when it's used with the i18n extra)
    def label(**opts)
      label_for(@page, **opts)
    end

    # The label for any page (it can pass along the I18n gem opts when it's used with the i18n extra)
    def label_for(page, **opts)
      opts[:format] ||= @vars[:format]
      localize(start_for(page.to_i), **opts)
    end

    # Period of the active page (used for nested units)
    def active_period
      [[@starting, @from].max, [@to - DAY, @ending].min] # include only last unit day
    end

    protected

    # Base class method for the setup of the unit variables
    def setup_unit_vars
      raise VariableError.new(self, :format, 'to be a strftime format', @vars[:format]) unless @vars[:format].is_a?(String)
      raise VariableError.new(self, :order, 'to be in [:asc, :desc]', @order) \
            unless %i[asc desc].include?(@order = @vars[:order])

      @starting, @ending = @vars[:period]
      raise VariableError.new(self, :period, 'to be a an Array of min and max local Time instances', @vars[:period]) \
            unless @starting.is_a?(Time) && @ending.is_a?(Time) && !@starting.utc? && !@ending.utc? && @starting <= @ending \
                   && (@utc_offset = @starting.utc_offset) == @ending.utc_offset
    end

    # Apply the strftime format to the time (overridden by the i18n extra when localization is required)
    def localize(time, opts)
      time.strftime(opts[:format])
    end

    # Simple trick to snap the page to its ordered start, without actually reordering anything in the internal structure.
    def snap(page)
      @order == :asc ? page - 1 : @pages - page
    end

    # Create a new local time at the beginning of the day
    def new_time(year, month = 1, day = 1)
      Time.new(year, month, day, 0, 0, 0, @utc_offset)
    end
  end
  require 'pagy/calendar/year'
  require 'pagy/calendar/month'
  require 'pagy/calendar/week'
  require 'pagy/calendar/day'

  class Calendar # :nodoc:
    UNITS = { year: Year, month: Month, week: Week, day: Day }.freeze

    # Create a subclass instance by unit name (internal use)
    def self.create(unit, vars)
      raise InternalError, "unit must be in #{UNITS.keys.inspect}; got #{unit}" unless UNITS.key?(unit)

      UNITS[unit].new(vars)
    end
  end
end
