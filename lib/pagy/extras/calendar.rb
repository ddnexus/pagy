# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/calendar
# frozen_string_literal: true

require 'pagy/calendar'

class Pagy # :nodoc:
  # Paginate based on calendar periods (year month week day)
  module CalendarExtra
    # Additions for the Backend module
    module Backend
      private

      # Return Pagy object and items
      def pagy_calendar(collection, vars = {})
        pagy = Calendar.new(pagy_calendar_get_vars(collection, vars))
        [pagy, pagy_calendar_get_items(collection, pagy)]
      end

      # Sub-method called only by #pagy_calendar: here for easy customization of variables by overriding.
      # You may want to override it in order to implement the dynamic set of the :minmax variable.
      def pagy_calendar_get_vars(_collection, vars)
        # vars[:minmax] ||= your_own_method_to_get_the_period_from(collection)
        vars[:page] ||= params[vars[:page_param] || DEFAULT[:page_param]]
        vars
      end

      # This method should be implemented in the application and should return the records
      # for the unit by selecting the records with Time from pagy.utc_from to pagy.utc_to
      def pagy_calendar_get_items(_collection, _pagy)
        # collection.your_own_method_to_get_the_items_with(pagy.utc_from, pagy.utc_to)
        raise NoMethodError, 'The pagy_calendar_get_items method must be implemented in the application and must return ' \
                             'the items for the unit by selecting the records with Time from pagy.utc_from to pagy.utc_to'
      end
    end
  end
  Backend.prepend CalendarExtra::Backend
end
