# See Pagy::Countless API documentation: https://ddnexus.github.io/pagy/api/calendar
# frozen_string_literal: true

class Pagy # :nodoc:
  class Calendar # :nodoc:
    # Calendar week subclass
    class Week < Calendar
      DEFAULT = { order:  :asc,      # rubocop:disable Style/MutableConstant
                  format: '%Y-%W',
                  first_wday: :sunday }
      WDAYS   = %i[sunday monday tuesday wednesday thursday friday saturday].freeze

      protected

      # Setup the calendar variables
      def setup_unit_vars
        super
        raise VariableError.new(self, :first_wday, "to be in #{WDAYS.inspect}", @vars[:first_wday]) \
              unless WDAYS.include?(@vars[:first_wday])

        if @vars[:offset]  # remove in pagy 6
          Warning.warn '[PAGY WARNING] The week :offset variable has been deprecated and will be ignored from pagy 6. ' \
                       "Set the :first_wday variable to be one of #{WDAYS.inspect} instead."
          @vars[:first_wday] = WDAYS[@vars[:offset] || 0]
        end
        @initial = @starting.beginning_of_week(@vars[:first_wday])
        @final   = @ending.next_week.beginning_of_week(@vars[:first_wday])
        @pages   = @last = (@final - @initial).to_i / 7.days.to_i
        @from    = starting_time_for(@page)
        @to      = @from + 7.days
      end

      # Starting time for the page
      def starting_time_for(page)
        @initial + offset_units_for(page).weeks
      end
    end
  end
end
