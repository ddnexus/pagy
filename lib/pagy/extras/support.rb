# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/support
# frozen_string_literal: true

class Pagy # :nodoc:
  # Extra support for features like: incremental, auto-incremental and infinite pagination
  module SupportExtra
    # Return the previous page URL string or nil
    def pagy_prev_url(pagy)
      pagy_url_for(pagy, pagy.prev) if pagy.prev
    end

    # Return the next page URL string or nil
    def pagy_next_url(pagy)
      pagy_url_for(pagy, pagy.next) if pagy.next
    end

    # Return the enabled/disabled HTML string for the previous page link
    def pagy_prev_html(pagy, link_extra: '')
      link = pagy_link_proc(pagy, link_extra:)
      pagy_nav_prev_html(pagy, link)
    end

    # Return the enabled/disabled HTML string for the next page link
    def pagy_next_html(pagy, link_extra: '')
      link = pagy_link_proc(pagy, link_extra:)
      pagy_nav_next_html(pagy, link)
    end

    # Conditionally return the HTML link tag string for the previous page
    def pagy_prev_link_tag(pagy)
      %(<link href="#{pagy_url_for(pagy, pagy.prev, html_escaped: true)}" rel="prev"/>) if pagy.prev
    end

    # Conditionally return the HTML link tag string for the next page
    def pagy_next_link_tag(pagy)
      %(<link href="#{pagy_url_for(pagy, pagy.next, html_escaped: true)}" rel="next"/>) if pagy.next
    end
  end
  Frontend.prepend SupportExtra
end
