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

    # Compact pagination for Foundation: it returns the html with the series of links to the pages
    # we use a numeric input tag to set the page and the Pagy.compact javascript to navigate
    def pagy_foundation_compact_nav(pagy, id=pagy_id)
      link, p_prev, p_next, p_page, p_pages = pagy_link_proc(pagy), pagy.prev, pagy.next, pagy.page, pagy.pages

      html = EMPTY + %(<nav id="#{id}" class="pagy-foundation-compact-nav" role="navigation" aria-label="Pagination">)
        html << link.call(MARKER, '', %(style="display: none;" ))
        (html << link.call(1, '', %(style="display: none;" ))) if defined?(TRIM)
        html << %(<div class="input-group">)
        html << (p_prev ? link.call(p_prev, pagy_t('pagy.nav.prev'), 'style="margin-bottom: 0px;" aria-label="previous" class="prev button primary"')
                        : %(<a style="margin-bottom: 0px;" class="prev button primary disabled" href="#">#{pagy_t('pagy.nav.prev')}</a>))
        input = %(<input class="input-group-field cell shrink" type="number" min="1" max="#{p_pages}" value="#{p_page}" style="width: #{p_pages.to_s.length+1}rem; padding: 0 0.3rem; margin: 0 0.3rem;">)
        html << %(<span class="input-group-label">#{pagy_t('pagy.compact', page_input: input, count: p_page, pages: p_pages)}</span>)
        html << (p_next ? link.call(p_next, pagy_t('pagy.nav.next'), 'style="margin-bottom: 0px;" aria-label="next" class="next button primary"')
                        : %(<a style="margin-bottom: 0px;" class="next button primary disabled" href="#">#{pagy_t('pagy.nav.next')}</a>))
      html << %(</div></nav>#{pagy_json_tag(:compact, id, MARKER, p_page, !!defined?(TRIM))})
    end

    # Responsive pagination for Foundation: it returns the html with the series of links to the pages
    # rendered by the Pagy.responsive javascript
    def pagy_foundation_responsive_nav(pagy, id=pagy_id)
      tags, link, p_prev, p_next, responsive = {}, pagy_link_proc(pagy), pagy.prev, pagy.next, pagy.responsive

      tags['before'] = EMPTY + '<ul class="pagination">'
      tags['before'] << (p_prev ? %(<li class="prev">#{link.call p_prev, pagy_t('pagy.nav.prev'), 'aria-label="previous"'}</li>)
                                : %(<li class="prev disabled">#{pagy_t('pagy.nav.prev')}</li>))
      responsive[:items].each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        tags[item.to_s] = if    item.is_a?(Integer); %(<li>#{link.call item}</li>)                        # page link
                          elsif item.is_a?(String) ; %(<li class="current">#{item}</li>)                  # active page
                          elsif item == :gap       ; %(<li class="ellipsis gap" aria-hidden="true"></li>) # page gap
                          end
      end
      tags['after'] = EMPTY + (p_next ? %(<li class="next">#{link.call p_next, pagy_t('pagy.nav.next'), 'aria-label="next"'}</li>)
                                      : %(<li class="next disabled">#{pagy_t('pagy.nav.next')}</li>))
      tags['after'] << '</ul>'
      script = pagy_json_tag(:responsive, id, tags,  responsive[:widths], responsive[:series])
      %(<nav id="#{id}" class="pagy-foundation-responsive-nav" aria-label="Pagination"></nav>#{script})
    end

  end
end
