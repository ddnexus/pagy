# See Pagy::Countless API documentation: https://ddnexus.github.io/pagy/api/calendar
# frozen_string_literal: true

class Pagy # :nodoc:
  class Calendar # :nodoc:
    # Calendar day subclass
    class Day < Calendar
      DEFAULT = { order:  :asc,      # rubocop:disable Style/MutableConstant
                  format: '%Y-%m-%d' }

      def page_for(time)
        super
        offset_page_for(page_offset(@initial, time.beginning_of_day))
      end

      protected

      # Setup the calendar variables
      def setup_unit_vars
        super
        @initial = @starting.beginning_of_day
        @final   = @ending.tomorrow.beginning_of_day
        @pages   = @last = page_offset(@initial, @final)
        @from    = starting_time_for(@page)
        @to      = @from.tomorrow
      end

      # Starting time for the page
      def starting_time_for(page)
        @initial + offset_units_for(page).days
      end

      private

      def page_offset(time_a, time_b)  # remove in 6.0
        (@with_zone ? (time_b.time - time_a.time) : (time_b - time_a)).to_i / 1.day
      end
    end
  end
end
