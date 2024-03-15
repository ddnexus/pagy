# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/support
# frozen_string_literal: true

class Pagy # :nodoc:
  # Extra support for features like: incremental, auto-incremental and infinite pagination
  module SupportExtra
    # Return the previous page URL string or nil
    def pagy_prev_url(pagy, absolute: false)
      pagy_url_for(pagy, pagy.prev, absolute:) if pagy.prev
    end

    # Return the next page URL string or nil
    def pagy_next_url(pagy, absolute: false)
      pagy_url_for(pagy, pagy.next, absolute:) if pagy.next
    end

    # Return the enabled/disabled previous page anchor tag
    def pagy_prev_a(pagy, text: pagy_t('pagy.prev'), aria_label: pagy_t('pagy.aria_label.prev'))
      a = pagy_anchor(pagy)
      prev_html(pagy, a, text:, aria_label:)
    end

    # Return the enabled/disabled next page anchor tag
    def pagy_next_a(pagy, text: pagy_t('pagy.next'), aria_label: pagy_t('pagy.aria_label.prev'))
      a = pagy_anchor(pagy)
      next_html(pagy, a, text:, aria_label:)
    end

    # Conditionally return the previous page link tag
    def pagy_prev_link(pagy, absolute: false)
      %(<link href="#{pagy_url_for(pagy, pagy.prev, absolute:)}"/>) if pagy.prev
    end

    # Conditionally return the next page link tag
    def pagy_next_link(pagy, absolute: false)
      %(<link href="#{pagy_url_for(pagy, pagy.next, absolute:)}"/>) if pagy.next
    end
  end
  Frontend.prepend SupportExtra
end
