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

    # Return the HTML string for the previous page link
    def pagy_prev_link(pagy, text: pagy_t('pagy.nav.prev'), link_extra: '')
      if pagy.prev
        %(<span class="page prev"><a href="#{
            pagy_url_for(pagy, pagy.prev, html_escaped: true)
          }" rel="prev" aria-label="previous" #{
            pagy.vars[:link_extra]
          } #{link_extra}>#{text}</a></span>)
      else
        %(<span class="page prev disabled">#{text}</span>)
      end
    end

    # Return the HTML string for the next page link
    def pagy_next_link(pagy, text: pagy_t('pagy.nav.next'), link_extra: '')
      if pagy.next
        %(<span class="page next"><a href="#{
            pagy_url_for(pagy, pagy.next, html_escaped: true)
          }" rel="next" aria-label="next" #{
            pagy.vars[:link_extra]
          } #{link_extra}>#{text}</a></span>)
      else
        %(<span class="page next disabled">#{text}</span>)
      end
    end

    # Return the HTML link tag for the previous page or nil
    def pagy_prev_link_tag(pagy)
      %(<link href="#{pagy_url_for(pagy, pagy.prev, html_escaped: true)}" rel="prev"/>) if pagy.prev
    end

    # Return the HTML link tag for the next page or nil
    def pagy_next_link_tag(pagy)
      %(<link href="#{pagy_url_for(pagy, pagy.next, html_escaped: true)}" rel="next"/>) if pagy.next
    end
  end
  Frontend.prepend SupportExtra
end
