# frozen_string_literal: true

class Pagy
  # Add calendar paginator
  Paginators.module_eval do
    private

    # Return the url for the calendar page at time
    def pagy_calendar_url_at(calendar, time, **)
      calendar.send(:calendar_at, time, **).page_url(1, **)
    end

    # Take a collection and an options Hash and return an array with 3 items: [calendar, pagy, results]
    def pagy_calendar(collection, options)
      allowed_options = Calendar::UNITS + %i[pagy active]
      raise ArgumentError, "keys must be in #{allowed_options.inspect}" \
            unless options.is_a?(Hash) && (options.keys - allowed_options).empty?

      options[:pagy]    ||= {}
      options[:request] ||= request
      unless options.key?(:active) && !options[:active]
        calendar, from, to = Calendar.send(:init, options, pagy_calendar_period(collection), params) do |unit, period|
                               pagy_calendar_counts(collection, unit, *period) if respond_to?(:pagy_calendar_counts)
                             end
        collection = pagy_calendar_filter(collection, from, to)
      end
      pagy, results = send(options[:pagy][:backend] || :pagy_offset, collection, **options[:pagy])
      [calendar, pagy, results]
    end
  end
end
