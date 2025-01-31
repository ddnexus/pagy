# frozen_string_literal: true

class Pagy
  # Add pagination filtering by calendar unit (:year, :quarter, :month, :week, :day) to the regular pagination
  Backend.module_eval do
    private

    # Take a collection and a conf Hash with keys in CONF_KEYS and return an array with 3 items: [calendar, pagy, results]
    def pagy_calendar(collection, conf)
      conf_keys = Calendar::UNITS + %i[pagy active]
      raise ArgumentError, "keys must be in #{conf_keys.inspect}" \
            unless conf.is_a?(Hash) && (conf.keys - conf_keys).empty?

      conf[:pagy] ||= {}
      unless conf.key?(:active) && !conf[:active]
        calendar, from, to = Calendar.send(:init, conf, pagy_calendar_period(collection), params) do |unit, period|
                               pagy_calendar_counts(collection, unit, *period) if respond_to?(:pagy_calendar_counts)
                             end
        collection = pagy_calendar_filter(collection, from, to)
      end
      pagy, results = send(conf[:pagy][:backend] || :pagy_offset, collection, **conf[:pagy])
      [calendar, pagy, results]
    end
  end

  module CalendarOverride
    def pagy_anchor(pagy, anchor_string: nil, **)
      return super unless (counts = pagy.options[:counts])   # Skip unless pagy_calendar_counts is defined

      left, right = %(<a#{%( #{anchor_string}) if anchor_string} href="#{pagy_page_url(pagy, PAGE_TOKEN, **)}")
                    .split(PAGE_TOKEN, 2)
      # Lambda used by all the helpers
      lambda do |page, text = pagy.label(page: page), classes: nil, aria_label: nil|
        count    = counts[page - 1]
        classes  = classes ? "#{classes} empty-page" : 'empty-page' if count.zero?
        info_key = count.zero? ? 'pagy.info.no_items' : 'pagy.info.single_page'
        title    = %( title="#{pagy_t(info_key, item_name: pagy_t('pagy.item_name', count:), count:)}")
        %(#{left}#{page}#{right}#{title}#{
          %( class="#{classes}") if classes}#{%( aria-label="#{aria_label}") if aria_label}>#{text}</a>)
      end
    end
  end
  Frontend.prepend CalendarOverride
end
