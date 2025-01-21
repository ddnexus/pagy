# frozen_string_literal: true

class Pagy
  # Add pagination filtering by calendar unit (:year, :quarter, :month, :week, :day) to the regular pagination
  # Additions for the Backend module
  module CalendarBackendAddOn
    CALENDAR_CONF_KEYS = (Offset::Calendar::UNITS + %i[pagy active]).freeze

    private

    # Take a collection and a conf Hash with keys in CONF_KEYS and return an array with 3 items: [calendar, pagy, results]
    def pagy_calendar(collection, conf)
      raise ArgumentError, "keys must be in #{CALENDAR_CONF_KEYS.inspect}" \
            unless conf.is_a?(Hash) && (conf.keys - CALENDAR_CONF_KEYS).empty?

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
  Backend.prepend CalendarBackendAddOn

  # Override the pagy_anchor
  module CalendarFrontendOverride
    # Consider the vars[:counts]
    def pagy_anchor(pagy, anchor_string: nil, **vars)
      return super unless (counts = pagy.vars[:counts])

      anchor_string &&= %( #{anchor_string})
      left, right = %(<a#{anchor_string} href="#{pagy_page_url(pagy, PAGE_TOKEN, **vars)}").split(PAGE_TOKEN, 2)
      # lambda used by all the helpers
      lambda do |page, text = pagy.label(page: page), classes: nil, aria_label: nil|
        count = counts[page - 1]
        if count.zero?
          classes  = "#{classes && (classes + ' ')}empty-page"
          info_key = 'pagy.info.no_items'
        else
          info_key = 'pagy.info.single_page'
        end
        title        = %( title="#{pagy_t(info_key, item_name: pagy_t('pagy.item_name', count:), count:)}")
        classes    &&= %( class="#{classes}")
        aria_label &&= %( aria-label="#{aria_label}")
        %(#{left}#{page}#{right}#{title}#{classes}#{aria_label}>#{text}</a>)
      end
    end
  end
  Frontend.prepend CalendarFrontendOverride

  # Additions for the Frontend module
  Url.module_eval do
    # Return the url for the calendar page at time
    def pagy_calendar_url_at(calendar, time, **)
      pagy_page_url(calendar.send(:calendar_at, time, **), 1, **)
    end
  end
end
