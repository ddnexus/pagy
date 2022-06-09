# See Pagy::Countless API documentation: https://ddnexus.github.io/pagy/api/calendar
# frozen_string_literal: true

class Pagy # :nodoc:
  class Calendar # :nodoc:
    # Calendar week subclass
    class Week < Calendar
      DEFAULT  = { order:  :asc,      # rubocop:disable Style/MutableConstant
                   format: '%Y-%W' }

      protected

      # Setup the calendar variables
      def setup_unit_vars
        super
        if @vars[:offset]  # remove in pagy 6
          Warning.warn '[PAGY WARNING] The week :offset variable has been deprecated and will be ignored from pagy 6. ' \
                       "Set the Date.beginning_of_week variable to be one of #{::Date::DAYS_INTO_WEEK.keys.inspect} instead."
          Date.beginning_of_week = ::Date::DAYS_INTO_WEEK.keys[@vars[:offset]]
        end
        @initial = @starting.beginning_of_week
        @final   = @ending.next_week.beginning_of_week
        @pages   = @last = page_offset(@initial, @final)
        @from    = starting_time_for(@page)
        @to      = @from.next_week
      end

      # Starting time for the page
      def starting_time_for(page)
        @initial.weeks_since(time_offset_for(page))
      end

      def page_offset_at(time)
        page_offset(@initial, time.beginning_of_week)
      end

      private

      def page_offset(time_a, time_b)  # remove in 6.0
        (time_b.time - time_a.time).to_i / 1.week
      end
    end
  end
end
