# See Pagy::Countless API documentation: https://ddnexus.github.io/pagy/api/calendar
# frozen_string_literal: true

class Pagy # :nodoc:
  class Calendar # :nodoc:
    # Calendar day subclass
    class Day < Calendar
      DEFAULT = { order:  :asc,      # rubocop:disable Style/MutableConstant
                  format: '%Y-%m-%d' }

      protected

      # Setup the calendar variables
      def setup_unit_vars
        super
        @initial = new_time(@starting.year, @starting.month, @starting.day)
        @final   = new_time(@ending.year, @ending.month, @ending.day) + DAY
        @pages   = @last = (@final - @initial).to_i / DAY
        @from    = start_for(@page)
        @to      = @from + DAY
      end

      # Time for the page
      def start_for(page)
        @initial + (snap(page) * DAY)
      end
    end
  end
end
