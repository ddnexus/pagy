# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/calendar
# frozen_string_literal: true

require_relative '../calendar'

class Pagy # :nodoc:
  # Add pagination filtering by calendar unit (:year, :quarter, :month, :week, :day) to the regular pagination
  module CalendarExtra
    # Additions for the Backend module
    module BackendAddOn
      CONF_KEYS = (Calendar::UNITS + %i[pagy active]).freeze

      private

      # Take a collection and a conf Hash with keys in CONF_KEYS and return an array with 3 items: [calendar, pagy, results]
      def pagy_calendar(collection, conf)
        raise ArgumentError, "keys must be in #{CONF_KEYS.inspect}" \
              unless conf.is_a?(Hash) && (conf.keys - CONF_KEYS).empty?

        conf[:pagy] ||= {}
        unless conf.key?(:active) && !conf[:active]
          calendar, from, to = Calendar.send(:init, conf, pagy_calendar_period(collection), params)
          if respond_to?(:pagy_calendar_counts)
            calendar.each_key do |unit|
              calendar[unit].vars[:counts] = pagy_calendar_counts(collection, unit, *calendar[unit].vars[:period])
            end
          end
          collection = pagy_calendar_filter(collection, from, to)
        end
        pagy, results = send(conf[:pagy][:backend] || :pagy, collection, conf[:pagy])  # use backend: :pagy when omitted
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

    # Override the pagy_anchor
    module FrontendOverride
      # Consider the vars[:count]
      def pagy_anchor(pagy, anchor_string: nil)
        return super unless (counts = pagy.vars[:counts])

        anchor_string &&= %( #{anchor_string})
        left, right = %(<a#{anchor_string} href="#{pagy_url_for(pagy, PAGE_TOKEN)}").split(PAGE_TOKEN, 2)
        # lambda used by all the helpers
        lambda do |page, text = pagy.label_for(page), classes: nil, aria_label: nil|
          count     = counts[page - 1]
          item_name = pagy_t('pagy.item_name', count:)
          if count.zero?
            classes = "#{classes && (classes + ' ')}empty-page"
            title   = %( title="#{pagy_t('pagy.info.no_items', item_name:, count:)}")
          else
            title   = %( title="#{pagy_t('pagy.info.single_page', item_name:, count:)}")
          end
          classes    = %( class="#{classes}") if classes
          aria_label = %( aria-label="#{aria_label}") if aria_label
          %(#{left}#{page}#{right}#{title}#{classes}#{aria_label}>#{text}</a>)
        end
      end
    end

    # Additions for the Frontend module
    module UrlHelperAddOn
      # Return the url for the calendar page at time
      def pagy_calendar_url_at(calendar, time, **opts)
        pagy_url_for(calendar.send(:calendar_at, time, **opts), 1, **opts)
      end
    end
  end
  Backend.prepend CalendarExtra::BackendAddOn, CalendarExtra::UrlHelperAddOn
  Frontend.prepend CalendarExtra::UrlHelperAddOn, CalendarExtra::FrontendOverride
end
