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
        @pages   = @last = (@with_zone ? (@final.time - @initial.time) : (@final - @initial)).to_i / 1.week
        @from    = starting_time_for(@page)
        @to      = @from.next_week
      end

      # Starting time for the page
      def starting_time_for(page)
        @initial + offset_units_for(page).weeks
      end
    end
  end
end
