# See Pagy::Countless API documentation: https://ddnexus.github.io/pagy/api/calendar
# frozen_string_literal: true

class Pagy # :nodoc:
  class Calendar # :nodoc:
    # Calendar year subclass
    class Year < Calendar
      DEFAULT = { order:  :asc,      # rubocop:disable Style/MutableConstant
                  format: '%Y' }

      protected

      # Setup the calendar variables
      def setup_unit_vars
        super
        @initial = new_time(@starting.year)
        @final   = new_time(@ending.year + 1)
        @pages   = @last = @final.year - @initial.year
        @from    = starting_time_for(@page)
        @to      = new_time(@from.year + 1)
      end

      # Starting time for the page
      def starting_time_for(page)
        new_time(@initial.year + offset_units_for(page))
      end
    end
  end
end
