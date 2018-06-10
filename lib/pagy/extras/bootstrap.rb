# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/bootstrap

class Pagy
  # Add nav helper for bootstrap pagination
  module Frontend

    # Pagination for bootstrap: it returns the html with the series of links to the pages
    def pagy_nav_bootstrap(pagy)
      tags, link, p_prev, p_next = '', pagy_link_proc(pagy, 'class="page-link"'.freeze), pagy.prev, pagy.next

      tags << (p_prev ? %(<li class="page-item prev">#{link.call p_prev, pagy_t('pagy.nav.prev'.freeze), 'aria-label="previous"'.freeze}</li>)
                      : %(<li class="page-item prev disabled"><a href="#" class="page-link">#{pagy_t('pagy.nav.prev'.freeze)}</a></li>))
      pagy.series.each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        tags << if    item.is_a?(Integer); %(<li class="page-item">#{link.call item}</li>)                                                               # page link
                elsif item.is_a?(String) ; %(<li class="page-item active">#{link.call item}</li>)                                                        # active page
                elsif item == :gap       ; %(<li class="page-item gap disabled"><a href="#" class="page-link">#{pagy_t('pagy.nav.gap'.freeze)}</a></li>) # page gap
                end
      end
      tags << (p_next ? %(<li class="page-item next">#{link.call p_next, pagy_t('pagy.nav.next'.freeze), 'aria-label="next"'.freeze}</li>)
                      : %(<li class="page-item next disabled"><a href="#" class="page-link">#{pagy_t('pagy.nav.next'.freeze)}</a></li>))
      %(<nav class="pagy-nav-boostrap pagination" role="navigation" aria-label="pager"><ul class="pagination">#{tags}</ul></nav>)
    end

  end
end

