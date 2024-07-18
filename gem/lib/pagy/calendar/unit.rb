# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/time'
require 'active_support/core_ext/date_and_time/calculations'
require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/integer/time'

class Pagy # :nodoc:
  class Calendar < Hash # :nodoc:
    # Base class for time units subclasses (Year, Quarter, Month, Week, Day)
    class Unit < Pagy
      attr_reader :order, :from, :to

      # Merge and validate the options, do some simple arithmetic and set a few instance variables
      def initialize(**vars)    # rubocop:disable Lint/MissingSuper
        raise InternalError, 'Pagy::Calendar::Unit is a base class; use one of its subclasses' \
            if instance_of?(Pagy::Calendar::Unit)

        assign_vars({ **Pagy::DEFAULT, **self.class::DEFAULT }, vars)
        assign_and_check(page: 1)
        assign_unit_vars
        check_overflow
        assign_prev_and_next
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
      # In case of out of range time, the :fit_time option avoids the outOfRangeError
      # and returns the closest page to the passed time argument (first or last page)
      def page_at(time, **opts)
        fit_time  = time
        fit_final = @final - 1
        unless time.between?(@initial, fit_final)
          raise OutOfRangeError.new(self, :time, "between #{@initial} and #{fit_final}", time) unless opts[:fit_time]

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
      def assign_unit_vars
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
        @order == :asc ? page - 1 : @last - page
      end

      # Period of the active page (used internally for nested units)
      def active_period
        [[@starting, @from].max, [@to - 1, @ending].min] # -1 sec: include only last unit day
      end

      # :nocov:
      # This method must be implemented by the unit subclass
      def starting_time_for(*)
        raise NoMethodError, 'the starting_time_for method must be implemented by the unit subclass'
      end

      # This method must be implemented by the unit subclass
      def page_offset_at(*)
        raise NoMethodError, 'the page_offset_at method must be implemented by the unit subclass'
      end
      # :nocov:
    end
  end
end
