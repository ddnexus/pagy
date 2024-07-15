# See Pagy::Countless API documentation: https://ddnexus.github.io/pagy/docs/api/calendar
# frozen_string_literal: true

class Pagy # :nodoc:
  class Calendar # :nodoc:
    # Month unit subclass
    class Month < Unit
      DEFAULT = { size: 12,   # rubocop:disable Style/MutableConstant
                  ends: false,
                  order: :asc,
                  format: '%b' }

      protected

      # Setup the calendar variables
      def assign_unit_vars
        super
        @initial = @starting.beginning_of_month
        @final   = @ending.next_month.beginning_of_month
        @last    = (months_in(@final) - months_in(@initial))
        @from    = starting_time_for(@page)
        @to      = @from.next_month
      end

      # Starting time for the page
      def starting_time_for(page)
        @initial.months_since(time_offset_for(page))
      end

      def page_offset_at(time)
        months_in(time.beginning_of_month) - months_in(@initial)
      end

      private

      # Number of months in time
      def months_in(time)
        (time.year * 12) + time.month
      end
    end
  end
end
