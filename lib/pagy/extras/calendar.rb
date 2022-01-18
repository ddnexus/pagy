# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/calendar
# frozen_string_literal: true

require 'pagy/calendar'

class Pagy # :nodoc:
  # Add pagination filtering by calendar unit (:year, :quarter, :month, :week, :day) to the regular pagination
  module CalendarExtra
    # Additions for the Backend module
    module Backend
      CONF_KEYS = (Calendar::UNITS + %i[pagy active]).freeze

      private

      # Take a collection and a conf Hash with keys in CONF_KEYS and return an array with 3 items: [calendar, pagy, results]
      def pagy_calendar(collection, conf)
        unless conf.is_a?(Hash) && (conf.keys - CONF_KEYS).empty? && conf.all? { |k, v| v.is_a?(Hash) || k == :active }
          raise ArgumentError, "keys must be in #{CONF_KEYS.inspect} and object values must be Hashes; got #{conf.inspect}"
        end

        conf[:pagy]          = {} unless conf[:pagy]  # use default Pagy object when omitted
        calendar, collection = pagy_setup_calendar(collection, conf) unless conf.key?(:active) && !conf[:active]
        pagy, results        = send(conf[:pagy][:backend] || :pagy, collection, conf[:pagy])  # use backend: :pagy when omitted
        [calendar, pagy, results]
      end

      # Setup and return the calendar objects and the filtered collection
      def pagy_setup_calendar(collection, conf)
        units = Calendar::UNITS & conf.keys # get the units in time length desc order
        raise ArgumentError, 'no calendar unit found in pagy_calendar configuration' if units.empty?

        page_param = conf[:pagy][:page_param] || DEFAULT[:page_param]
        units.each do |unit|  # set all the :page_param vars for later deletion
          unit_page_param           = :"#{unit}_#{page_param}"
          conf[unit][:page_param]   = unit_page_param
          conf[unit][:page]         = params[unit_page_param]
          conf[unit][:in_time_zone] = conf[:in_time_zone]
        end
        calendar = {}
        last_obj = nil
        units.each_with_index do |unit, index|
          params_to_delete    = units[(index + 1), units.size].map { |sub| conf[sub][:page_param] } + [page_param]
          conf[unit][:params] = lambda do |params|  # delete page_param from the sub-units
                                  params_to_delete.each { |p| params.delete(p.to_s) } # Hash#except missing from ruby 2.5 baseline
                                  params
                                end
          conf[unit][:period] = last_obj&.send(:active_period) || pagy_calendar_period(collection)
          calendar[unit]      = last_obj = Calendar.send(:create, unit, conf[unit])
        end
        [calendar, pagy_calendar_filter(collection, last_obj.from, last_obj.to)]
      end

      # This method must be implemented by the application
      def pagy_calendar_period(*)
        raise NoMethodError, 'the pagy_calendar_period method must be implemented by the application ' \
                             '(see https://ddnexus.github.io/pagy/extras/calendar#pagy_calendar_periodcollection)'
      end

      # This method must be implemented by the application
      def pagy_calendar_filter(*)
        raise NoMethodError, 'the pagy_calendar_filter method must be implemented by the application ' \
                             '(see https://ddnexus.github.io/pagy/extras/calendar#pagy_calendar_filtercollection-from-to)'
      end
    end
  end
  Backend.prepend CalendarExtra::Backend
end
