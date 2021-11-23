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
        @initial = week_start(@starting)
        @final   = week_start(@ending) + WEEK
        @pages   = @last = (@final - @initial).to_i / WEEK
        @from    = start_for(@page)
        @to      = @from + WEEK
      end

      # Time for the page
      def start_for(page)
        @initial + (snap(page) * WEEK)
      end

      private

      # Return the start of the week for local time
      def week_start(time)
        start = time - (((time.wday - @offset) * DAY) % WEEK)
        new_time(start.year, start.month, start.day)
      end
    end
  end
end
