# frozen_string_literal: true

class Pagy
  class Calendar
    # Day unit subclass
    class Day < Unit
      DEFAULT = { length:  31,
                  compact: true,
                  order:   :asc,
                  format:  '%d' }.freeze

      protected

      # Set up the calendar variables
      def assign_unit_vars
        super
        @initial = @starting.beginning_of_day
        @final   = @ending.tomorrow.beginning_of_day
        @last    = page_offset(@initial, @final)
        @from    = starting_time_for(@page)
        @to      = @from.tomorrow
      end

      # Starting time for the page
      def starting_time_for(page)
        @initial.days_since(time_offset_for(page))
      end

      def page_offset_at(time)
        page_offset(@initial, time.beginning_of_day)
      end

      private

      def page_offset(time_a, time_b)  # remove in 6.0
        (time_b.time - time_a.time).to_i / 1.day
      end
    end
  end
end
