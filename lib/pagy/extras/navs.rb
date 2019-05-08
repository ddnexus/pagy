# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/navs
# encoding: utf-8
# frozen_string_literal: true

require 'pagy/extras/shared'

class Pagy
  module Frontend

    # Javascript pagination: it returns a nav and a JSON tag used by the Pagy.nav javascript
    def pagy_nav_js(pagy, id=pagy_id)
      link, p_prev, p_next = pagy_link_proc(pagy), pagy.prev, pagy.next
      tags = { 'before' => p_prev ? %(<span class="page prev">#{link.call p_prev, pagy_t('pagy.nav.prev'), 'aria-label="previous"'}</span> )
                                  : %(<span class="page prev disabled">#{pagy_t('pagy.nav.prev')}</span> ),
               'link'   => %(<span class="page">#{link.call(MARK)}</span> ),
               'active' => %(<span class="page active">#{pagy.page}</span> ),
               'gap'    => %(<span class="page gap">#{pagy_t('pagy.nav.gap')}</span> ),
               'after'  => p_next ? %(<span class="page next">#{link.call p_next, pagy_t('pagy.nav.next'), 'aria-label="next"'}</span>)
                                  : %(<span class="page next disabled">#{pagy_t('pagy.nav.next')}</span>) }
      %(<nav id="#{id}" class="pagy-nav-js pagination" role="navigation" aria-label="pager"></nav>#{pagy_json_tag(:nav, id, tags, pagy.sequels, defined?(TRIM) && pagy.vars[:page_param])})
    end

    # Javascript combo pagination: it returns a nav and a JSON tag used by the Pagy.combo_nav javascript
    def pagy_combo_nav_js(pagy, id=pagy_id)
      link, p_prev, p_next, p_page, p_pages = pagy_link_proc(pagy), pagy.prev, pagy.next, pagy.page, pagy.pages

      html = EMPTY + %(<nav id="#{id}" class="pagy-combo-nav-js-js pagination" role="navigation" aria-label="pager">)
      html << (p_prev ? %(<span class="page prev">#{link.call p_prev, pagy_t('pagy.nav.prev'), 'aria-label="previous"'}</span> )
                      : %(<span class="page prev disabled">#{pagy_t('pagy.nav.prev')}</span> ))
      input = %(<input type="number" min="1" max="#{p_pages}" value="#{p_page}" style="padding: 0; text-align: center; width: #{p_pages.to_s.length+1}rem;">)
      html << %(<span class="pagy-combo-input" style="margin: 0 0.6rem;">#{pagy_t('pagy.combo_nav_js', page_input: input, count: p_page, pages: p_pages)}</span> )
      html << (p_next ? %(<span class="page next">#{link.call p_next, pagy_t('pagy.nav.next'), 'aria-label="next"'}</span>)
                      : %(<span class="page next disabled">#{pagy_t('pagy.nav.next')}</span>))
      html << %(</nav>#{pagy_json_tag(:combo_nav, id, p_page, pagy_marked_link(link), defined?(TRIM) && pagy.vars[:page_param])})
    end

  end
end
