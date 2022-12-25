# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/calendar
# frozen_string_literal: true

require 'pagy/calendar'
require 'pagy/calendar/helper'

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

        conf[:pagy] = {} unless conf[:pagy]  # use default Pagy object when omitted
        unless conf.key?(:active) && !conf[:active]
          calendar, from, to = Calendar::Helper.send(:init, conf, pagy_calendar_period(collection), params)
          collection         = pagy_calendar_filter(collection, from, to)
        end
        pagy, results = send(conf[:pagy][:backend] || :pagy, collection, conf[:pagy])  # use backend: :pagy when omitted
        [calendar, pagy, results]
      end

      def pagy_calendar_url_at(calendar, time)
        pagy_url_for(calendar.send(:last_object_at, time), 1)
      end

      # This method must be implemented by the application
      def pagy_calendar_period(*)
        raise NoMethodError, 'the pagy_calendar_period method must be implemented by the application ' \
                             '(see https://ddnexus.github.io/pagy/docs/extras/calendar/#pagy-calendar-period-collection)'
      end

      # This method must be implemented by the application
      def pagy_calendar_filter(*)
        raise NoMethodError, 'the pagy_calendar_filter method must be implemented by the application ' \
                             '(see https://ddnexus.github.io/pagy/docs/extras/calendar/#pagy-calendar-filter-collection-from-to)'
      end
    end
  end
  Backend.prepend CalendarExtra::Backend
end
