# See Pagy::Countless API documentation: https://ddnexus.github.io/pagy/api/calendar
# frozen_string_literal: true

require 'pagy'
require 'date'

class Pagy # :nodoc:
  DEFAULT[:local_minmax] = []          # Min and max Time period must be set by the user
  DEFAULT[:unit]         = :month      # Time unit allowed %i[year month week day]
  DEFAULT[:week_offset]  = 0           # Day offset from Sunday (0: Sunday; 1: Monday;... 6: Saturday)
  DEFAULT[:order]        = :asc        # Time direction of pagination
  DEFAULT[:year_format]  = '%Y'        # strftime format for :year unit
  DEFAULT[:month_format] = '%Y-%m'     # strftime format for :month unit
  DEFAULT[:week_format]  = '%Y-%W'     # strftime format for :week unit
  DEFAULT[:day_format]   = '%Y-%m-%d'  # strftime format for :day unit

  # Paginate a Time period by units (year, month, week or day)
  class Calendar < Pagy
    attr_reader :utc_from, :utc_to, :unit, :week_offset, :order
    attr_writer :count, :in

    # Merge and validate the options, do some simple arithmetic and set a few instance variables
    def initialize(vars) # rubocop:disable Lint/MissingSuper
      normalize_vars(vars)
      setup_vars(page: 1, week_offset: 0)
      setup_unit_vars
      setup_params_var
      raise OverflowError.new(self, :page, "in 1..#{@last}", @page) if @page > @last

      @prev = (@page - 1 unless @page == 1)
      @next = @page == @last ? (1 if @vars[:cycle]) : @page + 1
    end

    # Generate a label for each page, with the specific `Time` period it refers to
    # (it can pass along the I18n gem opts when it's used with the i18n extra)
    def label_for(page, **opts)
      snap = snap(page.to_i)
      time = case @unit
             when :year  then new_time(@initial.year + snap)
             when :month then bump_month(@initial, snap)
             when :week  then @initial + (snap * WEEK)
             when :day   then @initial + (snap * DAY)
             else raise InternalError, "expected @unit to be in [:year, :month, :week, :day]; got #{@unit.inspect}"
             end
      opts[:format] ||= @vars[:"#{@unit}_format"]
      localize(time, **opts)
    end

    # The label for the current page
    # (it can pass along the I18n gem opts when it's used with the i18n extra)
    def label(**opts)
      label_for(@page, **opts)
    end

    DAY  = 60 * 60 * 24
    WEEK = DAY * 7

    protected

    def setup_unit_vars
      (units = %i[year month week day]).each do |unit|
        raise VariableError.new(self, :format, 'to be a strftime format', @vars[:"#{unit}_format"]) \
              unless @vars[:"#{unit}_format"].is_a?(String)
      end
      raise VariableError.new(self, :unit, "to be in #{units.inspect}", @unit) \
            unless units.include?(@unit = @vars[:unit])
      raise VariableError.new(self, :order, 'to be in [:asc, :desc]', @order) \
            unless %i[asc desc].include?(@order = @vars[:order])

      min, max = @vars[:local_minmax]
      raise VariableError.new(self, :local_minmax, 'to be a an Array of min and max local Time instances', @vars[:local_minmax]) \
            unless min.is_a?(Time) && max.is_a?(Time) && !min.utc? && !max.utc? && min <= max \
                   && (@utc_offset = min.utc_offset) == max.utc_offset

      send :"setup_#{@unit}_vars", min, max
    end

    # IMPORTANT: all the Time objects created and passed as arguments MUST be local!

    # @initial:  beginning of the first day of the period that encloses the min local time
    # @final:    beginning of the first day of the NEXT period AFTER the period that encloses the max local time
    # @utc_from: beginning of the first day of the period of the current page as UTC time
    # @utc_to:   beginning of the first day of the NEXT period AFTER the current page as UTC time

    # Setup the calendar vars when the unit is :year
    def setup_year_vars(min, max)
      @initial  = new_time(min.year)
      @final    = new_time(max.year + 1)
      @pages    = @last = @final.year - @initial.year
      @utc_from = new_time(@initial.year + snap).utc
      @utc_to   = new_time(@initial.year + snap + 1).utc
    end

    # Setup the calendar vars when the unit is :month
    def setup_month_vars(min, max)
      @initial  = new_time(min.year, min.month)
      @final    = bump_month(max)
      @pages    = @last = months(@final) - months(@initial)
      @utc_from = bump_month(@initial, snap).utc
      @utc_to   = bump_month(@initial, snap + 1).utc
    end

    # Setup the calendar vars when the unit is :week
    def setup_week_vars(min, max)
      @initial  = week_start(min)
      @final    = week_start(max) + WEEK
      @pages    = @last = (@final - @initial).to_i / WEEK
      @utc_from = (@initial + (snap * WEEK)).utc
      @utc_to   = @utc_from + WEEK
    end

    # Setup the calendar vars when the unit is :day
    def setup_day_vars(min, max)
      @initial  = new_time(min.year, min.month, min.day)
      @final    = new_time(max.year, max.month, max.day) + DAY
      @pages    = @last = (@final - @initial).to_i / DAY
      @utc_from = (@initial + (snap * DAY)).utc
      @utc_to   = @utc_from + DAY
    end

    # Apply the strftime format to the time
    # (overridden by the i18n extra when localization is required)
    def localize(time, **opts)
      time.strftime(opts[:format])
    end

    private

    # Simple trick to snap the page into its ordered position,
    # without actually reordering anything in the internal structure
    def snap(page = @page)
      @order == :asc ? page - 1 : @pages - page
    end

    # Create a new local time at the beginning of the day
    def new_time(year, month = 1, day = 1)
      Time.new(year, month, day, 0, 0, 0, @utc_offset)
    end

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

    # Return the start of the week for local time
    def week_start(time)
      start = time - (((time.wday - @week_offset) * DAY) % WEEK)
      new_time(start.year, start.month, start.day)
    end
  end
end
