# frozen_string_literal: true

class Pagy
  class Calendar
    # Mixin for month based unit periods
    # It is used for month and quarter, but you could use it to implement less common unit of 6, 4, 2 months
    # (see the https://ddnexus.github.io/pagy/api/calendar#custom-units sections for details).
    # The including class must set the MONTHS duration for the unit and the usual DEFAULT.
    module MonthMixin
      protected

      # Setup the calendar variables
      def setup_unit_vars
        super
        @months  = self.class::MONTHS  # number of months in the unit
        @initial = unit_starting_time_for(@starting)
        @final   = add_months_to(unit_starting_time_for(@ending), @months)
        @pages   = @last = (months_in(@final) - months_in(@initial)) / @months
        @from    = starting_time_for(@page)
        @to      = add_months_to(@from, @months)
      end

      # Starting time for the page
      def starting_time_for(page)
        add_months_to(@initial, offset_units_for(page) * @months)
      end

      private

      # Unit starting time for time
      def unit_starting_time_for(time)
        # remove 1 month for 0-11 calculations and add it back for 1-12 conversion
        starting_month = (@months * ((time.month - 1) / @months)) + 1
        new_time(time.year, starting_month)
      end

      # Number of months in time
      def months_in(time)
        (time.year * 12) + time.month
      end

      # Add months to time
      def add_months_to(time, months)
        months += months_in(time) - 1             # remove 1 month for 0-11 calculations
        new_time(months / 12, (months % 12) + 1)  # add 1 month back for 1-12 conversion
      end
    end
  end
end
