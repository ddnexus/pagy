# frozen_string_literal: true

require_relative '../core/shiftable'
require_relative '../core/rangeable'
require_relative '../core/seriable'

class Pagy
  class Calendar
    # Base class for time units subclasses (Year, Quarter, Month, Week, Day)
    class Unit < Pagy
      include Core::Rangeable
      include Core::Seriable
      include Core::Shiftable

      DEFAULT = { page: 1 }.freeze

      # Merge and validate the options, do some simple arithmetic and set a few instance variables
      def initialize(**)    # rubocop:disable Lint/MissingSuper
        assign_options(**)
        assign_and_check(page: 1)
        assign_unit_variables
        return unless in_range? { @page <= @last }

        assign_previous_and_next
      end

      attr_reader :order, :from, :to

      # Called by false in_range?
      def assign_empty_page_variables
        @in = @from = @to = 0                        # options relative to the actual page
        edge = @order == :asc ? @final : @initial    # get the edge of the range (neat, but any time would do)
        @from = @to = edge                           # set both to the edge time (a >=&&< query will get no records)
        @previous = @last
      end

      # The label for any page (it can forward the I18n gem options when it's used with the i18n extra)
      def label(page: @page, **options)
        options[:format] ||= @options[:format]
        localize(starting_time_for(page.to_i), **options)  # page could be a string
      end

      def calendar? = true

      protected

      def label_sequels(series)
        series.map { |s| s.map { |item| item == :gap ? :gap : label(page: item) } }
      end

      # The page that includes time
      # In case of time out of range, the :fit_time option avoids the RangeError
      # and returns the closest page to the passed time argument (first or last page)
      def page_at(time, **options)
        fit_time  = time
        fit_final = @final - 1
        unless time.between?(@initial, fit_final)
          raise RangeError.new(self, :time, "between #{@initial} and #{fit_final}", time) unless options[:fit_time]

          if time < @final
            fit_time = @initial
            ordinal  = 'first'
          else
            fit_time = fit_final
            ordinal  = 'last'
          end
          warn "Pagy::Calendar#page_at: Rescued #{time} out of range by returning the #{ordinal} page."
        end
        offset = page_offset_at(fit_time)   # offset starts from 0
        @order == :asc ? offset + 1 : @last - offset
      end

      # Base class method for the setup of the unit variables (subclasses must implement it and call super)
      def assign_unit_variables
        raise OptionError.new(self, :format, 'to be a strftime format', @options[:format]) unless @options[:format].is_a?(String)
        raise OptionError.new(self, :order, 'to be in [:asc, :desc]', @order) \
              unless %i[asc desc].include?(@order = @options[:order])

        @starting, @ending = @options[:period]
        raise OptionError.new(self, :period, 'to be a an Array of min and max TimeWithZone instances', @options[:period]) \
              unless @starting.is_a?(ActiveSupport::TimeWithZone) \
                  && @ending.is_a?(ActiveSupport::TimeWithZone) && @starting <= @ending
      end

      # Apply the strftime format to the time.
      # IMPORTANT: If you need localization of the Calendar beside :en, you must use the rails-I18n gem.
      # In order to enable it, uncomment the specific lines at the end of the config/pagy.rb initializer.
      # Notice that the calendar localization does not require you to use the pagy i18n extra,
      # which is all about translation and not localization.
      def localize(time, **options)
        time.strftime(options[:format])
      end

      # The number of time units to offset from the @initial time, in order to get the ordered starting time for the page.
      # Used in starting_time_for(page) where page starts from 1 (e.g. page to starting_time means subtracting 1)
      def time_offset_for(page)
        @order == :asc ? page - 1 : @last - page
      end

      # Period of the active page (used internally for nested units)
      def active_period
        [[@starting, @from].max, [@to - 1, @ending].min] # -1 sec: include only last unit day
      end

      # :nocov:
      # This method must be implemented by the Unit subclass
      def starting_time_for(*)
        raise NoMethodError, 'the starting_time_for method must be implemented by the unit subclass'
      end

      # This method must be implemented by the Unit subclass
      def page_offset_at(*)
        raise NoMethodError, 'the page_offset_at method must be implemented by the unit subclass'
      end
      # :nocov:
    end
  end
end
