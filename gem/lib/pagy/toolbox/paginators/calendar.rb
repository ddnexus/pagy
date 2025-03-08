# frozen_string_literal: true

class Pagy
  module CalendarPaginator
    module_function

    # Take a collection and a configuration Hash and return an array with 3 items: [calendar, pagy, results]
    def paginate(context, collection, config)
      context.instance_eval do
        allowed_options = Calendar::UNITS + %i[offset disabled request]
        raise ArgumentError, "keys must be in #{allowed_options.inspect}" \
              unless config.is_a?(Hash) && (config.keys - allowed_options).empty?

        config[:request]  = Request.new(config[:request] || request)
        config[:offset] ||= {}
        unless config[:disabled]
          calendar, from, to =
            Calendar.send(:init, config,
                          pagy_calendar_period(collection),
                          config[:request].query_hash) do |unit, period|
              pagy_calendar_counts(collection, unit, *period) if respond_to?(:pagy_calendar_counts)
            end
          collection = pagy_calendar_filter(collection, from, to)
        end
        pagy, records = pagy(:offset, collection, **config[:offset])
        [calendar, pagy, records]
      end
    end
  end
end
