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
        @initial = @starting.beginning_of_day
        @final   = @ending.tomorrow.beginning_of_day
        @pages   = @last = (@final - @initial).to_i / 1.day
        @from    = starting_time_for(@page)
        @to      = @from.tomorrow
      end

      # Starting time for the page
      def starting_time_for(page)
        @initial + offset_units_for(page).days
      end
    end
  end
end
