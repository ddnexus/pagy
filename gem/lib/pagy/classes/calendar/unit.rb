# frozen_string_literal: true

require_relative '../../modules/abilities/shiftable'
require_relative '../../modules/abilities/rangeable'

class Pagy
  class Calendar
    # Base class for time units subclasses (Year, Quarter, Month, Week, Day)
    #
    # To define a "bimester" unit you should:
    # - Define a `Pagy::Calendar::Bimester` class
    # - Add the `:bimester` unit symbol in the `Pagy::Calendar::UNITS`
    # - Ensure the desc durtion order of the UNITS (i.e. insert it between `:quarter` and `:month`)
    class Unit < Pagy
      DEFAULT = { page: 1 }.freeze

      include Rangeable
      include Shiftable

      def initialize(**)    # rubocop:disable Lint/MissingSuper
        assign_options(**)
        assign_and_check(page: 1)
        assign_unit_variables
        return unless in_range? { @page <= @last }

        assign_previous_and_next
      end

      attr_reader :order, :from, :to, :previous, :last

      protected

      def calendar? = true

      # Called by false in_range?
      def assign_empty_page_variables
        @in = @from = @to = 0                        # options relative to the actual page
        edge = @order == :asc ? @final : @initial    # get the edge of the range (neat, but any time would do)
        @from = @to = edge                           # set both to the edge time (a >=&&< query will get no records)
        @previous = @last
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
        @order = @options[:order]
        @starting, @ending = @options[:period]
        raise OptionError.new(self, :period, 'to be a an Array of min and max TimeWithZone instances', @options[:period]) \
              unless @starting.is_a?(ActiveSupport::TimeWithZone) \
                  && @ending.is_a?(ActiveSupport::TimeWithZone) && @starting <= @ending
      end

      # Apply the strftime format to the time.
      # Localization other than :en, require the rails-I18n gem.
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
    end
  end
end
