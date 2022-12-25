# See Pagy::Countless API documentation: https://ddnexus.github.io/pagy/docs/api/calendar
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
