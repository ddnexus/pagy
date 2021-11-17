# See Pagy::Countless API documentation: https://ddnexus.github.io/pagy/api/calendar
# frozen_string_literal: true

require 'pagy'
require 'date'

class Pagy # :nodoc:
  DEFAULT[:year_format]  = '%Y'        # strftime format for :year unit
  DEFAULT[:month_format] = '%Y-%m'     # strftime format for :month unit
  DEFAULT[:week_format]  = '%Y-%W'     # strftime format for :week unit
  DEFAULT[:day_format]   = '%Y-%m-%d'  # strftime format for :day unit
  DEFAULT[:week_offset]  = 0           # Day offset from Sunday (0: Sunday; 1: Monday;... 6: Saturday)
  DEFAULT[:time_order]   = :asc        # Time direction of pagination

  # Base class for time units subclasses (Year, Month, Week, Day)
  class Calendar < Pagy
    DAY  = 60 * 60 * 24
    WEEK = DAY * 7

    attr_reader :utc_from, :utc_to, :time_order

    # Create a subclass instance
    def self.create(unit, vars)
      raise InternalError, "unit must be in #{UNITS.keys.inspect}; got #{unit}" unless UNITS.key?(unit)

      UNITS[unit].new(vars)
    end

    # Merge and validate the options, do some simple arithmetic and set a few instance variables
    def initialize(vars) # rubocop:disable Lint/MissingSuper
      raise InternalError, 'Pagy::Calendar is a base class; use one of its subclasses.' if instance_of?(Pagy::Calendar)

      normalize_vars(vars)
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

    # Return the minmax of the current page/unit (used by the extra for the next level minmax)
    def current_unit_minmax
      [@utc_from.getlocal(@utc_offset), @utc_to.getlocal(@utc_offset)]
    end

    protected

    def setup_unit_vars(format)
      raise VariableError.new(self, format, 'to be a strftime format', @vars[format]) unless @vars[format].is_a?(String)
      raise VariableError.new(self, :time_order, 'to be in [:asc, :desc]', @time_order) \
            unless %i[asc desc].include?(@time_order = @vars[:time_order])

      min, max = @vars[:minmax]
      raise VariableError.new(self, :minmax, 'to be a an Array of min and max local Time instances', @vars[:minmax]) \
            unless min.is_a?(Time) && max.is_a?(Time) && !min.utc? && !max.utc? && min <= max \
                   && (@utc_offset = min.utc_offset) == max.utc_offset

      [min, max]
    end

    # Apply the strftime format to the time (overridden by the i18n extra when localization is required)
    def localize(time, opts)
      time.strftime(opts[:format])
    end

    # Simple trick to snap the page into its ordered position, without actually reordering anything in the internal structure
    def snap(page = @page)
      @time_order == :asc ? page - 1 : @pages - page
    end

    # Create a new local time at the beginning of the day
    def new_time(year, month = 1, day = 1)
      Time.new(year, month, day, 0, 0, 0, @utc_offset)
    end

    # Calendar year subclass
    class Year < Calendar
      # Setup the calendar vars when the unit is :year
      def setup_unit_vars
        min, max  = super(:year_format)
        @initial  = new_time(min.year)
        @final    = new_time(max.year + 1)
        @pages    = @last = @final.year - @initial.year
        @utc_from = new_time(@initial.year + snap).utc
        @utc_to   = new_time(@initial.year + snap + 1).utc
      end

      # Generate a label for each page (it can pass along the I18n gem opts when it's used with the i18n extra)
      def label_for(page, **opts)
        opts[:format] ||= @vars[:year_format]
        localize(new_time(@initial.year + snap(page.to_i)), **opts)
      end
    end

    # Calendar month subclass
    class Month < Calendar
      # Setup the calendar vars when the unit is :month
      def setup_unit_vars
        min, max  = super(:month_format)
        @initial  = new_time(min.year, min.month)
        @final    = bump_month(max)
        @pages    = @last = months(@final) - months(@initial)
        @utc_from = bump_month(@initial, snap).utc
        @utc_to   = bump_month(@initial, snap + 1).utc
      end

      # Generate a label for each page (it can pass along the I18n gem opts when it's used with the i18n extra)
      def label_for(page, **opts)
        opts[:format] ||= @vars[:month_format]
        localize(bump_month(@initial, snap(page.to_i)), **opts)
      end

      private

      # Months in local time
      def months(time)
        (time.year * 12) + time.month
      end

      # Add 1 or more months to local time
      def bump_month(time, months = 1)
        months += months(time)
        year  = months / 12
        month = months % 12
        month.zero? ? new_time(year - 1, 12) : new_time(year, month)
      end
    end

    # Calendar week subclass
    class Week < Calendar
      attr_reader :week_offset

      # Setup the calendar vars when the unit is :week
      def setup_unit_vars
        setup_vars(week_offset: 0)
        min, max  = super(:week_format)
        @initial  = week_start(min)
        @final    = week_start(max) + WEEK
        @pages    = @last = (@final - @initial).to_i / WEEK
        @utc_from = (@initial + (snap * WEEK)).utc
        @utc_to   = @utc_from + WEEK
      end

      # Generate a label for each page (it can pass along the I18n gem opts when it's used with the i18n extra)
      def label_for(page, **opts)
        opts[:format] ||= @vars[:week_format]
        localize(@initial + (snap(page.to_i) * WEEK), **opts)
      end

      private

      # Return the start of the week for local time
      def week_start(time)
        start = time - (((time.wday - @week_offset) * DAY) % WEEK)
        new_time(start.year, start.month, start.day)
      end
    end

    # Calendar day subclass
    class Day < Calendar
      # Setup the calendar vars when the unit is :day
      def setup_unit_vars
        min, max  = super(:day_format)
        @initial  = new_time(min.year, min.month, min.day)
        @final    = new_time(max.year, max.month, max.day) + DAY
        @pages    = @last = (@final - @initial).to_i / DAY
        @utc_from = (@initial + (snap * DAY)).utc
        @utc_to   = @utc_from + DAY
      end

      # Generate a label for each page (it can pass along the I18n gem opts when it's used with the i18n extra)
      def label_for(page, **opts)
        opts[:format] ||= @vars[:day_format]
        localize(@initial + (snap(page.to_i) * DAY), **opts)
      end
    end
    # After all the subclasses are defined
    UNITS = { year: Year, month: Month, week: Week, day: Day }.freeze
  end
end
