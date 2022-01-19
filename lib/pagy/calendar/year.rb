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
        @initial = @starting.beginning_of_year
        @final   = @ending.next_year.beginning_of_year
        @pages   = @last = @final.year - @initial.year
        @from    = starting_time_for(@page)
        @to      = @from.next_year
      end

      # Starting time for the page
      def starting_time_for(page)
        @initial.years_since(offset_units_for(page))
      end
    end
  end
end
