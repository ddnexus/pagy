# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/bootstrap
# encoding: utf-8
# frozen_string_literal: true

require 'pagy/extras/shared'

class Pagy
  module Frontend

    # Pagination for bootstrap: it returns the html with the series of links to the pages
    def pagy_bootstrap_nav(pagy)
      link, p_prev, p_next = pagy_link_proc(pagy, 'class="page-link"'), pagy.prev, pagy.next

      html = EMPTY + (p_prev ? %(<li class="page-item prev">#{link.call p_prev, pagy_t('pagy.nav.prev'), 'aria-label="previous"'}</li>)
                             : %(<li class="page-item prev disabled"><a href="#" class="page-link">#{pagy_t('pagy.nav.prev')}</a></li>))
      pagy.series.each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << if    item.is_a?(Integer); %(<li class="page-item">#{link.call item}</li>)                                                               # page link
                elsif item.is_a?(String) ; %(<li class="page-item active">#{link.call item}</li>)                                                        # active page
                elsif item == :gap       ; %(<li class="page-item gap disabled"><a href="#" class="page-link">#{pagy_t('pagy.nav.gap')}</a></li>) # page gap
                end
      end
      html << (p_next ? %(<li class="page-item next">#{link.call p_next, pagy_t('pagy.nav.next'), 'aria-label="next"'}</li>)
                      : %(<li class="page-item next disabled"><a href="#" class="page-link">#{pagy_t('pagy.nav.next')}</a></li>))
      %(<nav class="pagy-bootstrap-nav pagination" role="navigation" aria-label="pager"><ul class="pagination">#{html}</ul></nav>)
    end

    # Javascript pagination for bootstrap: it returns a nav and a JSON tag used by the Pagy.nav javascript
    def pagy_bootstrap_nav_js(pagy, id=pagy_id)
      link, p_prev, p_next = pagy_link_proc(pagy, 'class="page-link"'), pagy.prev, pagy.next
      tags = { 'before' => p_prev ? %(<ul class="pagination"><li class="page-item prev">#{link.call p_prev, pagy_t('pagy.nav.prev'), 'aria-label="previous"'}</li>)
                                  : %(<ul class="pagination"><li class="page-item prev disabled"><a href="#" class="page-link">#{pagy_t('pagy.nav.prev')}</a></li>),
               'link'   => %(<li class="page-item">#{mark = link.call(MARK)}</li>),
               'active' => %(<li class="page-item active">#{mark}</li>),
               'gap'    => %(<li class="page-item gap disabled"><a href="#" class="page-link">#{pagy_t('pagy.nav.gap')}</a></li>),
               'after'  => p_next ? %(<li class="page-item next">#{link.call p_next, pagy_t('pagy.nav.next'), 'aria-label="next"'}</li></ul>)
                                  : %(<li class="page-item next disabled"><a href="#" class="page-link">#{pagy_t('pagy.nav.next')}</a></li></ul>) }
      %(<nav id="#{id}" class="pagy-bootstrap-nav-js pagination" role="navigation" aria-label="pager"></nav>#{pagy_json_tag(:nav, id, tags, pagy.sequels, defined?(TRIM) && pagy.vars[:page_param])})
    end

    # Javascript combo pagination for bootstrap: it returns a nav and a JSON tag used by the Pagy.combo_nav javascript
    def pagy_bootstrap_combo_nav_js(pagy, id=pagy_id)
      link, p_prev, p_next, p_page, p_pages = pagy_link_proc(pagy), pagy.prev, pagy.next, pagy.page, pagy.pages

      html = %(<nav id="#{id}" class="pagy-bootstrap-combo-nav-js pagination" role="navigation" aria-label="pager">) + %(<div class="btn-group" role="group">)
      html << (p_prev ? link.call(p_prev, pagy_t('pagy.nav.prev'), 'aria-label="previous" class="prev btn btn-primary"')
                      : %(<a class="prev btn btn-primary disabled" href="#">#{pagy_t('pagy.nav.prev')}</a>))
      input = %(<input type="number" min="1" max="#{p_pages}" value="#{p_page}" class="text-primary" style="padding: 0; border: none; text-align: center; width: #{p_pages.to_s.length+1}rem;">)
      html << %(<div class="pagy-combo-input btn btn-primary disabled" style="white-space: nowrap;">#{pagy_t('pagy.combo_nav_js', page_input: input, count: p_page, pages: p_pages)}</div>)
      html << (p_next ? link.call(p_next, pagy_t('pagy.nav.next'), 'aria-label="next" class="next btn btn-primary"')
                      : %(<a class="next btn btn-primary disabled" href="#">#{pagy_t('pagy.nav.next')}</a>))
      html << %(</div></nav>#{pagy_json_tag(:combo_nav, id, p_page, pagy_marked_link(link), defined?(TRIM) && pagy.vars[:page_param])})
    end

  end
end
