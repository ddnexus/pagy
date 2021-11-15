# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/calendar
# frozen_string_literal: true

require 'pagy/calendar'

class Pagy # :nodoc:
  # Paginate based on calendar periods (year month week day) plus the regular pagination
  module CalendarExtra
    # Additions for the Backend module
    module Backend
      CONF_KEYS = %i[year month week day pagy skip].freeze

      private

      # Take a collection and a conf Hash with keys in [:year, :month: week, :day, :pagy]  and Hash values of pagy variables
      # Return a hash with 3 items:
      # 0. Array of pagy calendar unit objects
      # 1. Pagy object
      # 2. Array of results
      def pagy_calendar(collection, conf)
        unless conf.is_a?(Hash) && (conf.keys - CONF_KEYS).empty? && conf.all? { |k, v| v.is_a?(Hash) || k == :skip }
          raise ArgumentError, "keys must be in #{CONF_KEYS.inspect} and object values must be Hashes; got #{conf.inspect}"
        end

        conf[:pagy]          = {} unless conf[:pagy]  # use default Pagy object when omitted
        calendar, collection = pagy_setup_calendar(collection, conf) unless conf[:skip]
        pagy, result         = send(conf[:pagy][:backend] || :pagy, collection, conf[:pagy])  # use backend: :pagy when omitted
        [calendar, pagy, result]
      end

      # Setup the calendar objects and return them with the filtered collection
      def pagy_setup_calendar(collection, conf)
        units = Calendar::UNITS.keys & conf.keys
        page_param = conf[:pagy][:page_param] || DEFAULT[:page_param]
        units.each do |unit|  # set all the :page_param vars for later deletion
          unit_page_param = :"#{unit}_#{page_param}"
          conf[unit][:page_param] = unit_page_param
          conf[unit][:page]       = params[unit_page_param]
        end
        calendar      = {}
        last_calendar = nil
        last_minmax   = minmax = pagy_calendar_minmax(collection)
        units.each_with_index do |unit, index|
          params_to_delete    = units[(index + 1), units.size].map { |sub| conf[sub][:page_param] } + [page_param]
          conf[unit][:params] = lambda do |params|  # delete page_param from the sub-units
                                  params_to_delete.each { |p| params.delete(p.to_s) } # except implemented after 2.5
                                  params
                                end
          conf[unit][:minmax] = [[minmax.first, last_minmax.first].max, [minmax.last, last_minmax.last].min]
          calendar[unit]      = last_calendar = Calendar.create(unit, conf[unit])
          last_minmax         = calendar[unit].current_unit_minmax # set the minmax for the next unit
        end
        filtered = pagy_calendar_filtered(collection, last_calendar.utc_from, last_calendar.utc_to)
        [calendar, filtered]
      end

      # This method must be implemented by the application.
      # It must return an Array with the minimum and maximum Time objects from the collection,
      # converted to the local time of the user
      def pagy_calendar_minmax(*)
        # collection.your_own_method_to_get_the_minmax
        raise NoMethodError, 'the pagy_calendar_minmax method must be implemented by the application and must return ' \
                             'an Array with the minimum and maximum local Time objects of the collection'
      end

      # This method must be implemented by the application.
      # It receives the main collection argument and must return a filtered version of it.
      # The filter logic must be equivalent to {utc_time >= pagy.utc_from && utc_time < pagy.utc_to}
      def pagy_calendar_filtered(*)
        # collection.your_own_method_to_filter_with(pagy.utc_from, pagy.utc_to)
        raise NoMethodError, 'the pagy_calendar_filtered method must be implemented by the application and must return the ' \
                             'collection filtered by a logic equivalent to {utc_time >= pagy.utc_from && utc_time < pagy.utc_to}'
      end
    end
  end
  Backend.prepend CalendarExtra::Backend
end
