# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/bulma
# encoding: utf-8
# frozen_string_literal: true

require 'pagy/extras/shared'

class Pagy
  module Frontend

    # Pagination for Bulma: it returns the html with the series of links to the pages
    def pagy_bulma_nav(pagy)
      link, p_prev, p_next = pagy_link_proc(pagy), pagy.prev, pagy.next

      html = EMPTY + (p_prev ? link.call(p_prev, pagy_t('pagy.nav.prev'), 'class="pagination-previous" aria-label="previous page"')
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
      %(<nav class="pagy-bulma-nav pagination is-centered" role="navigation" aria-label="pagination">#{html}</nav>)
    end

    # Compact pagination for Bulma: it returns the html with the series of links to the pages
    # we use a numeric input tag to set the page and the Pagy.compact javascript to navigate
    def pagy_bulma_compact_nav(pagy, id=pagy_id)
      link, p_prev, p_next, p_page, p_pages = pagy_link_proc(pagy), pagy.prev, pagy.next, pagy.page, pagy.pages

      html = EMPTY + %(<nav id="#{id}" class="pagy-bulma-compact-nav" role="navigation" aria-label="pagination">)
        html << link.call(MARKER, '', 'style="display: none;"')
        (html << link.call(1, '', %(style="display: none;"))) if defined?(TRIM)
        html << %(<div class="field is-grouped is-grouped-centered" role="group">)
        html << (p_prev ? %(<p class="control">#{link.call(p_prev, pagy_t('pagy.nav.prev'), 'class="button" aria-label="previous page"')}</p>)
                        : %(<p class="control"><a class="button" disabled>#{pagy_t('pagy.nav.prev')}</a></p>))
        input = %(<input class="input" type="number" min="1" max="#{p_pages}" value="#{p_page}" style="padding: 0; text-align: center; width: #{p_pages.to_s.length+1}rem; margin:0 0.3rem;">)
        html << %(<div class="pagy-compact-input control level is-mobile">#{pagy_t('pagy.compact', page_input: input, count: p_page, pages: p_pages)}</div>)
        html << (p_next ? %(<p class="control">#{link.call(p_next, pagy_t('pagy.nav.next'), 'class="button" aria-label="next page"')}</p>)
                        : %(<p class="control"><a class="button" disabled>#{pagy_t('pagy.nav.next')}</a></p>))
      html << %(</div></nav>#{pagy_json_tag(:compact, id, MARKER, p_page, !!defined?(TRIM))})
    end

    # Responsive pagination for Bulma: it returns the html with the series of links to the pages
    # rendered by the Pagy.responsive javascript
    def pagy_bulma_responsive_nav(pagy, id=pagy_id)
      tags, link, p_prev, p_next, responsive = {}, pagy_link_proc(pagy), pagy.prev, pagy.next, pagy.responsive

      tags['before'] = EMPTY + (p_prev ? link.call(p_prev, pagy_t('pagy.nav.prev'), 'class="pagination-previous" aria-label="previous page"')
                                       : %(<a class="pagination-previous" disabled>#{pagy_t('pagy.nav.prev')}</a>))
      tags['before'] << (p_next ? link.call(p_next, pagy_t('pagy.nav.next'), 'class="pagination-next" aria-label="next page"')
                                : %(<a class="pagination-next" disabled>#{pagy_t('pagy.nav.next')}</a>))
      tags['before'] << '<ul class="pagination-list">'
      responsive[:items].each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        tags[item.to_s] = if    item.is_a?(Integer); %(<li>#{link.call item, item, %(class="pagination-link" aria-label="goto page #{item}")}</li>)
                          elsif item.is_a?(String) ; %(<li>#{link.call item, item, %(class="pagination-link is-current" aria-current="page" aria-label="page #{item}")}</li>)
                          elsif item == :gap       ; %(<li><span class="pagination-ellipsis">#{pagy_t('pagy.nav.gap')}</span></li>)
                          end
      end
      tags['after'] = '</ul>'
      script = pagy_json_tag(:responsive, id, tags,  responsive[:widths], responsive[:series])
      %(<nav id="#{id}" class="pagy-bulma-responsive-nav pagination is-centered" role="navigation" aria-label="pagination"></nav>#{script})
    end

  end
end
