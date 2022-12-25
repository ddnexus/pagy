# See Pagy::Countless API documentation: https://ddnexus.github.io/pagy/docs/api/calendar
# frozen_string_literal: true

class Pagy # :nodoc:
  class Calendar # :nodoc:
    # Calendar quarter subclass
    class Quarter < Calendar
      DEFAULT = { order:  :asc,      # rubocop:disable Style/MutableConstant
                  format: '%Y-Q%q' } # '%q' token

      # The label for any page, with the substitution of the '%q' token
      def label_for(page, opts = {})
        starting_time = starting_time_for(page.to_i)  # page could be a string
        opts[:format] = (opts[:format] || @vars[:format]).gsub('%q') { (starting_time.month / 3.0).ceil }
        localize(starting_time, opts)
      end

      protected

      # Setup the calendar variables
      def setup_unit_vars
        super
        @initial = @starting.beginning_of_quarter
        @final   = @ending.next_quarter.beginning_of_quarter
        @pages   = @last = (months_in(@final) - months_in(@initial)) / 3
        @from    = starting_time_for(@page)
        @to      = @from.next_quarter
      end

      # Starting time for the page
      def starting_time_for(page)
        @initial.months_since(time_offset_for(page) * 3)
      end

      def page_offset_at(time)
        (months_in(time.beginning_of_quarter) - months_in(@initial)) / 3
      end

      private

      # Number of months in time
      def months_in(time)
        (time.year * 12) + time.month
      end
    end
  end
end
