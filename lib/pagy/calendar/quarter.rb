# See Pagy::Countless API documentation: https://ddnexus.github.io/pagy/api/calendar
# frozen_string_literal: true

require_relative 'month_mixin'

class Pagy # :nodoc:
  class Calendar # :nodoc:
    # Calendar quarter subclass
    class Quarter < Calendar
      DEFAULT = { order:  :asc,      # rubocop:disable Style/MutableConstant
                  format: '%Y-Q%q' } # '%q' token
      MONTHS  = 3  # number of months of the unit
      include MonthMixin

      # The label for any page, with the substitution of the '%q' token
      def label_for(page, opts = {})
        start_time    = start_for(page.to_i)
        opts[:format] = (opts[:format] || @vars[:format]).gsub('%q') { (start_time.month / 4) + 1 }
        localize(start_time, opts)
      end
    end
  end
end
