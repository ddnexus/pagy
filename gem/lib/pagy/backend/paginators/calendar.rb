# frozen_string_literal: true

class Pagy
  # Add calendar pagynator
  Backend.module_eval do
    private

    # Take a collection and an options Hash and return an array with 3 items: [calendar, pagy, results]
    def pagy_calendar(collection, options)
      allowed_options = Calendar::UNITS + %i[pagy active]
      raise ArgumentError, "keys must be in #{allowed_options.inspect}" \
            unless options.is_a?(Hash) && (options.keys - allowed_options).empty?

      options[:pagy] ||= {}
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

  module CalendarOverride
    def pagy_create_anchor_lambda(pagy, anchor_string: nil, **)
      return super unless (counts = pagy.options[:counts])   # No overriding without :counts

      left, right = %(<a#{%( #{anchor_string}) if anchor_string} href="#{pagy_page_url(pagy, PAGE_TOKEN, **)}")
                    .split(PAGE_TOKEN, 2)
      # Lambda used by all the helpers
      lambda do |page, text = pagy.label(page: page), classes: nil, aria_label: nil|
        count    = counts[page - 1]
        classes  = classes ? "#{classes} empty-page" : 'empty-page' if count.zero?
        info_key = count.zero? ? 'pagy.info.no_items' : 'pagy.info.single_page'
        title    = %( title="#{pagy_translate(info_key, item_name: pagy_translate('pagy.item_name', count:), count:)}")
        %(#{left}#{page}#{right}#{title}#{
          %( class="#{classes}") if classes}#{%( aria-label="#{aria_label}") if aria_label}>#{text}</a>)
      end
    end
  end
  Frontend.prepend CalendarOverride
end
