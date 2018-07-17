# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/materialize
# frozen_string_literal: true

class Pagy
  # Add nav helper for materialize pagination
  module Frontend

    # Pagination for materialize: it returns the html with the series of links to the pages
    def pagy_nav_materialize(pagy)
      html, link, p_prev, p_next = +'', pagy_link_proc(pagy), pagy.prev, pagy.next
      html << (p_prev ? %(<li class="waves-effect prev">#{link.call p_prev, '<i class="material-icons">chevron_left</i>', 'aria-label="previous"'}</li>)
                      : %(<li class="prev disabled"><a href="#"><i class="material-icons">chevron_left</i></a></li>))
      pagy.series.each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << if    item.is_a?(Integer); %(<li class="waves-effect">#{link.call item}</li>)                                             # page link
                elsif item.is_a?(String) ; %(<li class="active">#{link.call item}</li>)                                                   # active page
                elsif item == :gap       ; %(<li class="gap disabled"><a href="#">#{pagy_t('pagy.nav.gap')}</a></li>)   # page gap
                end
      end
      html << (p_next ? %(<li class="waves-effect next">#{link.call p_next, '<i class="material-icons">chevron_right</i>', 'aria-label="next"'}</li>)
                      : %(<li class="next disabled"><a href="#"><i class="material-icons">chevron_right</i></a></li>))
      %(<div class="pagy-nav-materialize pagination" role="navigation" aria-label="pager"><ul class="pagination">#{html}</ul></div>)
    end

  end
end
