# frozen_string_literal: true

class Pagy
  # Add pagination filtering by calendar unit (:year, :quarter, :month, :week, :day) to the regular pagination
  Backend.module_eval do
    private

    # Take a collection and a conf Hash with keys in CONF_KEYS and return an array with 3 items: [calendar, pagy, results]
    def pagy_calendar(collection, conf)
      conf_keys = Offset::Calendar::UNITS + %i[pagy active]
      raise ArgumentError, "keys must be in #{conf_keys.inspect}" \
            unless conf.is_a?(Hash) && (conf.keys - conf_keys).empty?

      conf[:pagy] ||= {}
      unless conf.key?(:active) && !conf[:active]
        calendar, from, to = Offset::Calendar.send(:init, conf, pagy_calendar_period(collection), params) do |unit, period|
                               pagy_calendar_counts(collection, unit, *period) if respond_to?(:pagy_calendar_counts)
                             end
        collection = pagy_calendar_filter(collection, from, to)
      end
      pagy, results = send(conf[:pagy][:backend] || :pagy_offset, collection, **conf[:pagy])
      [calendar, pagy, results]
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
