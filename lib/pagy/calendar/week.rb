# See Pagy::Countless API documentation: https://ddnexus.github.io/pagy/api/calendar
# frozen_string_literal: true

class Pagy # :nodoc:
  class Calendar # :nodoc:
    # Calendar week subclass
    class Week < Calendar
      DEFAULT = { order:  :asc,      # rubocop:disable Style/MutableConstant
                  format: '%Y-%W',
                  offset: 0 }

      protected

      # Setup the calendar variables
      def setup_unit_vars
        setup_vars(offset: 0)
        super
        @initial = unit_starting_time_for(@starting)
        @final   = unit_starting_time_for(@ending) + WEEK
        @pages   = @last = (@final - @initial).to_i / WEEK
        @from    = starting_time_for(@page)
        @to      = @from + WEEK
      end

      # Starting time for the page
      def starting_time_for(page)
        @initial + (offset_units_for(page) * WEEK)
      end

      private

      # Unit starting time for time
      def unit_starting_time_for(time)
        starting_time = time - (((time.wday - @offset) * DAY) % WEEK)
        new_time(starting_time.year, starting_time.month, starting_time.day)
      end
    end
  end
end
