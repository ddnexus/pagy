# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/pagy
# frozen_string_literal: true

class Pagy
  # Frontend modules are specially optimized for performance.
  # The resulting code may not look very elegant, but produces the best benchmarks
  Frontend.class_eval do
    # Return the previous page URL string or nil
    def pagy_prev_url(pagy, **vars)
      pagy_page_url(pagy, pagy.prev, **vars) if pagy.prev
    end

    # Return the next page URL string or nil
    def pagy_next_url(pagy, **vars)
      pagy_page_url(pagy, pagy.next, **vars) if pagy.next
    end

    # Return the enabled/disabled previous page anchor tag
    def pagy_prev_a(pagy, text: pagy_t('pagy.prev'), aria_label: pagy_t('pagy.aria_label.prev'), **vars)
      a = pagy_anchor(pagy, **vars)
      prev_a(pagy, a, text:, aria_label:)
    end

    # Return the enabled/disabled next page anchor tag
    def pagy_next_a(pagy, text: pagy_t('pagy.next'), aria_label: pagy_t('pagy.aria_label.next'), **vars)
      a = pagy_anchor(pagy, **vars)
      next_a(pagy, a, text:, aria_label:)
    end

    # Conditionally return the previous page link tag
    def pagy_prev_link(pagy, **vars)
      %(<link href="#{pagy_page_url(pagy, pagy.prev, **vars)}"/>) if pagy.prev
    end

    # Conditionally return the next page link tag
    def pagy_next_link(pagy, **vars)
      %(<link href="#{pagy_page_url(pagy, pagy.next, **vars)}"/>) if pagy.next
    end
  end
end
