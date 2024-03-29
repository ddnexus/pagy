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

    # Return the HTML string for the enabled/disabled previous page link
    def pagy_prev_html(pagy, text: pagy_t('pagy.prev'), link_extra: '')
      link = pagy_link_proc(pagy, link_extra:)
      prev_html(pagy, link, text:)
    end

    # Return the HTML string for the enabled/disabled next page link
    def pagy_next_html(pagy, text: pagy_t('pagy.next'), link_extra: '')
      link = pagy_link_proc(pagy, link_extra:)
      next_html(pagy, link, text:)
    end

    # Conditionally return the HTML link tag string for the previous page
    def pagy_prev_link_tag(pagy, absolute: false)
      %(<link href="#{pagy_url_for(pagy, pagy.prev, absolute:)}" rel="prev"/>) if pagy.prev
    end

    # Conditionally return the HTML link tag string for the next page
    def pagy_next_link_tag(pagy, absolute: false)
      %(<link href="#{pagy_url_for(pagy, pagy.next, absolute:)}" rel="next"/>) if pagy.next
    end
  end
  Frontend.prepend SupportExtra
end
