# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/bulma
# frozen_string_literal: true

class Pagy
  # Add nav helper for Bulma pagination
  module Frontend

    def pagy_nav_bulma(pagy)
      html, link, p_prev, p_next = +'', pagy_link_proc(pagy), pagy.prev, pagy.next

      html << (p_prev ? link.call(p_prev, pagy_t('pagy.nav.prev'), 'class="pagination-previous" aria-label="previous page"')
                      : %(<a class="pagination-previous" disabled>#{pagy_t('pagy.nav.prev')}</a>))
      html << (p_next ? link.call(p_next, pagy_t('pagy.nav.next'), 'class="pagination-next" aria-label="next page"')
                      : %(<a class="pagination-next" disabled>#{pagy_t('pagy.nav.next')}</a>))
      html << '<ul class="pagination-list">'
      pagy.series.each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << if    item.is_a?(Integer); %(<li>#{link.call item, item, %(class="pagination-link" aria-label="goto page #{item}") }</li>)                           # page link
                elsif item.is_a?(String) ; %(<li>#{link.call item, item, %(class="pagination-link is-current" aria-label="page #{item}" aria-current="page")}</li>)  # active page
                elsif item == :gap       ; %(<li><span class="pagination-ellipsis">#{pagy_t('pagy.nav.gap')}</span></li>)                                            # page gap
                end
      end
      html << '</ul>'
      %(<nav class="pagy-nav-bulma pagination is-centered" role="navigation" aria-label="pagination">#{html}</nav>)
    end

  end
end
