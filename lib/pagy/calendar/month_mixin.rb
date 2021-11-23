# frozen_string_literal: true

class Pagy
  class Calendar
    # Mixin for month based unit periods
    # It is used for month and quarter, but you could use it to implement less common unit of 6, 4, 2 months
    # (see the https://ddnexus.github.io/pagy/api/calendar#custom-units sections for details).
    # The class that includes it needs to set the MONTH duration for the unit and the usual DEFAULT.
    module MonthMixin
      protected

      # Setup the calendar variables
      def setup_unit_vars
        super
        @months  = self.class::MONTHS  # number of months in the unit
        @initial = new_time(@starting.year, beginning_month(@starting.month))
        @final   = add_to(new_time(@ending.year, beginning_month(@ending.month)), @months)
        @pages   = @last = (months_in(@final) - months_in(@initial)) / @months
        @from    = start_for(@page)
        @to      = add_to(@from, @months)
      end

      # Time for the page
      def start_for(page)
        add_to(@initial, snap(page) * @months)
      end

      # Return the beginning month for the unit (e.g. quarter) that includes the month argument
      def beginning_month(month)
        (@months * ((month - 1) / @months)) + 1
      end

      private

      # Months in time
      def months_in(time)
        (time.year * 12) + time.month
      end

      # Add months to time
      def add_to(time, months)
        months += months_in(time)
        year  = months / 12
        month = months % 12
        month.zero? ? new_time(year - 1, 12) : new_time(year, month)
      end
    end
  end
end
