# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/foundation
# frozen_string_literal: true

class Pagy
  # Add nav helper for foundation pagination
  module Frontend

    # Pagination for foundation: it returns the html with the series of links to the pages
    def pagy_nav_foundation(pagy)
      html, link, p_prev, p_next = +'', pagy_link_proc(pagy), pagy.prev, pagy.next

      html << (p_prev ? %(<li>#{link.call p_prev, pagy_t('pagy.nav.prev'), 'aria-label="previous"'}</li>)
                      : %(<li class="disabled">#{pagy_t('pagy.nav.prev')}</li>))
      pagy.series.each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << if    item.is_a?(Integer); %(<li>#{link.call item}</li>)                                                                # page link
                elsif item.is_a?(String) ; %(<li class="current"><span class="show-for-sr">You're on page</span>#{link.call item}</li>) # active page
                elsif item == :gap       ; %(<li class="ellipsis" aria-hidden="true"></li>)                                             # page gap
                end
      end
      html << (p_next ? %(<li>#{link.call p_next, pagy_t('pagy.nav.next'), 'aria-label="next"'}</li>)
                      : %(<li class="disabled">#{pagy_t('pagy.nav.next')}</li>))
      %(<nav class="pagy-nav-foundation" aria-label="Pagination"><ul class="pagination">#{html}</ul></nav>)
    end

  end
end
