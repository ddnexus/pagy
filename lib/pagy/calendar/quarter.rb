# See Pagy::Countless API documentation: https://ddnexus.github.io/pagy/api/calendar
# frozen_string_literal: true

require_relative 'month_mixin'

class Pagy # :nodoc:
  class Calendar # :nodoc:
    # Calendar quarter subclass
    class Quarter < Calendar
      DEFAULT = { order:  :asc,      # rubocop:disable Style/MutableConstant
                  format: '%Y-Q%q' }
      MONTHS  = 3  # number of months of the unit
      include MonthMixin
    end
  end
end
