# See Pagy::Countless API documentation: https://ddnexus.github.io/pagy/api/calendar
# frozen_string_literal: true

class Pagy # :nodoc:
  class Calendar # :nodoc:
    # Calendar month subclass
    class Month < Calendar
      DEFAULT = { order:  :asc,      # rubocop:disable Style/MutableConstant
                  format: '%Y-%m' }

      protected

      # Setup the calendar variables
      def setup_unit_vars
        super
        @initial = new_time(@starting.year, @starting.month)
        @final   = bump_month(@ending)
        @pages   = @last = months(@final) - months(@initial)
        @from    = start_for(@page)
        @to      = bump_month(@from)
      end

      # Time for the page
      def start_for(page)
        bump_month(@initial, snap(page))
      end

      private

      # Months in local time
      def months(time)
        (time.year * 12) + time.month
      end

      # Add 1 or more months to local time
      def bump_month(time, months = 1)
        months += months(time)
        year  = months / 12
        month = months % 12
        month.zero? ? new_time(year - 1, 12) : new_time(year, month)
      end
    end
  end
end
