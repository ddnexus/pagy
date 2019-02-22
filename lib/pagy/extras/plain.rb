# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/plain
# encoding: utf-8
# frozen_string_literal: true

require 'pagy/extras/shared'

class Pagy
  module Frontend

    # added alias for symmetry
    alias :pagy_plain_nav :pagy_nav

    # Plain compact pagination: it returns the html with the series of links to the pages
    # we use a numeric input tag to set the page and the Pagy.compact javascript to navigate
    def pagy_plain_compact_nav(pagy, id=pagy_id)
      link, p_prev, p_next, p_page, p_pages = pagy_link_proc(pagy), pagy.prev, pagy.next, pagy.page, pagy.pages

      html = EMPTY + %(<nav id="#{id}" class="pagy-plain-compact-nav pagination" role="navigation" aria-label="pager">)
        html << link.call(MARKER, '', %(style="display: none;" ))
        (html << link.call(1, '', %(style="display: none;" ))) if defined?(TRIM)
        html << (p_prev ? %(<span class="page prev">#{link.call p_prev, pagy_t('pagy.nav.prev'), 'aria-label="previous"'}</span> )
                        : %(<span class="page prev disabled">#{pagy_t('pagy.nav.prev')}</span> ))
        input = %(<input type="number" min="1" max="#{p_pages}" value="#{p_page}" style="padding: 0; text-align: center; width: #{p_pages.to_s.length+1}rem;">)
        html << %(<span class="pagy-compact-input" style="margin: 0 0.6rem;">#{pagy_t('pagy.compact', page_input: input, count: p_page, pages: p_pages)}</span> )
        html << (p_next ? %(<span class="page next">#{link.call p_next, pagy_t('pagy.nav.next'), 'aria-label="next"'}</span>)
                        : %(<span class="page next disabled">#{pagy_t('pagy.nav.next')}</span>))
      html << %(</nav>#{pagy_json_tag(:compact, id, MARKER, p_page, !!defined?(TRIM))})
    end

    # Plain responsive pagination: it returns the html with the series of links to the pages
    # rendered by the Pagy.responsive javascript
    def pagy_plain_responsive_nav(pagy, id=pagy_id)
      tags, link, p_prev, p_next, responsive = {}, pagy_link_proc(pagy), pagy.prev, pagy.next, pagy.responsive

      tags['before'] = (p_prev ? %(<span class="page prev">#{link.call p_prev, pagy_t('pagy.nav.prev'), 'aria-label="previous"'}</span> )
                               : %(<span class="page prev disabled">#{pagy_t('pagy.nav.prev')}</span> ))
      responsive[:items].each do |item|  # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        tags[item.to_s] = if    item.is_a?(Integer); %(<span class="page">#{link.call item}</span> )             # page link
                          elsif item.is_a?(String) ; %(<span class="page active">#{item}</span> )                # current page
                          elsif item == :gap       ; %(<span class="page gap">#{pagy_t('pagy.nav.gap')}</span> ) # page gap
                          end
      end
      tags['after'] = (p_next ? %(<span class="page next">#{link.call p_next, pagy_t('pagy.nav.next'), 'aria-label="next"'}</span>)
                              : %(<span class="page next disabled">#{pagy_t('pagy.nav.next')}</span>))
      script = pagy_json_tag(:responsive, id, tags,  responsive[:widths], responsive[:series])
      %(<nav id="#{id}" class="pagy-plain-responsive-nav pagination" role="navigation" aria-label="pager"></nav>#{script})
    end

  end
end
