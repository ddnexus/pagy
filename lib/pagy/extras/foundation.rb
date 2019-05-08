# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/foundation
# encoding: utf-8
# frozen_string_literal: true

require 'pagy/extras/shared'

class Pagy
  module Frontend

    # Pagination for Foundation: it returns the html with the series of links to the pages
    def pagy_foundation_nav(pagy)
      link, p_prev, p_next = pagy_link_proc(pagy), pagy.prev, pagy.next

      html = EMPTY + (p_prev ? %(<li class="prev">#{link.call p_prev, pagy_t('pagy.nav.prev'), 'aria-label="previous"'}</li>)
                             : %(<li class="prev disabled">#{pagy_t('pagy.nav.prev')}</li>))
      pagy.series.each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << if    item.is_a?(Integer); %(<li>#{link.call item}</li>)                        # page link
                elsif item.is_a?(String) ; %(<li class="current">#{item}</li>)                  # active page
                elsif item == :gap       ; %(<li class="ellipsis gap" aria-hidden="true"></li>) # page gap
                end
      end
      html << (p_next ? %(<li class="next">#{link.call p_next, pagy_t('pagy.nav.next'), 'aria-label="next"'}</li>)
                      : %(<li class="next disabled">#{pagy_t('pagy.nav.next')}</li>))
      %(<nav class="pagy-foundation-nav" role="navigation" aria-label="Pagination"><ul class="pagination">#{html}</ul></nav>)
    end

    # Javascript pagination for foundation: it returns a nav and a JSON tag used by the Pagy.nav javascript
    def pagy_foundation_nav_js(pagy, id=pagy_id)
      link, p_prev, p_next = pagy_link_proc(pagy), pagy.prev, pagy.next
      tags = { 'before' => ( '<ul class="pagination">' \
                           + (p_prev ? %(<li class="prev">#{link.call(p_prev, pagy_t('pagy.nav.prev'), 'aria-label="previous"')}</li>)
                                     : %(<li class="prev disabled">#{pagy_t('pagy.nav.prev')}</li>)) ),
               'link'   => %(<li>#{link.call(MARK)}</li>),
               'active' => %(<li class="current">#{pagy.page}</li>),
               'gap'    => %(<li class="ellipsis gap" aria-hidden="true"></li>),
               'after'  => ( (p_next ? %(<li class="next">#{link.call(p_next, pagy_t('pagy.nav.next'), 'aria-label="next"')}</li>)
                                     : %(<li class="next disabled">#{pagy_t('pagy.nav.next')}</li>)) \
                           + '</ul>' ) }
      %(<nav id="#{id}" class="pagy-foundation-nav-js" role="navigation" aria-label="Pagination"></nav>#{pagy_json_tag(:nav, id, tags, pagy.sequels, defined?(TRIM) && pagy.vars[:page_param])})
    end

    # Javascript combo pagination for Foundation: it returns a nav and a JSON tag used by the Pagy.combo_nav javascript
    def pagy_foundation_combo_nav_js(pagy, id=pagy_id)
      link, p_prev, p_next, p_page, p_pages = pagy_link_proc(pagy), pagy.prev, pagy.next, pagy.page, pagy.pages

      html = %(<nav id="#{id}" class="pagy-foundation-combo-nav-js" role="navigation" aria-label="Pagination">) + %(<div class="input-group">)
      html << (p_prev ? link.call(p_prev, pagy_t('pagy.nav.prev'), 'style="margin-bottom: 0px;" aria-label="previous" class="prev button primary"')
                      : %(<a style="margin-bottom: 0px;" class="prev button primary disabled" href="#">#{pagy_t('pagy.nav.prev')}</a>))
      input = %(<input class="input-group-field cell shrink" type="number" min="1" max="#{p_pages}" value="#{p_page}" style="width: #{p_pages.to_s.length+1}rem; padding: 0 0.3rem; margin: 0 0.3rem;">)
      html << %(<span class="input-group-label">#{pagy_t('pagy.combo_nav_js', page_input: input, count: p_page, pages: p_pages)}</span>)
      html << (p_next ? link.call(p_next, pagy_t('pagy.nav.next'), 'style="margin-bottom: 0px;" aria-label="next" class="next button primary"')
                      : %(<a style="margin-bottom: 0px;" class="next button primary disabled" href="#">#{pagy_t('pagy.nav.next')}</a>))
      html << %(</div></nav>#{pagy_json_tag(:combo_nav, id, p_page, pagy_marked_link(link), defined?(TRIM) && pagy.vars[:page_param])})
    end

  end
end
