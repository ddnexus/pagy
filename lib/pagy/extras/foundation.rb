# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/foundation
# frozen_string_literal: true

require 'pagy/extras/shared'

class Pagy
  module Frontend

    # Pagination for Foundation: it returns the html with the series of links to the pages
    def pagy_nav_foundation(pagy)
      html, link, p_prev, p_next = +'', pagy_link_proc(pagy), pagy.prev, pagy.next

      html << (p_prev ? %(<li class="prev">#{link.call p_prev, pagy_t('pagy.nav.prev'), 'aria-label="previous"'}</li>)
                      : %(<li class="prev disabled">#{pagy_t('pagy.nav.prev')}</li>))
      pagy.series.each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << if    item.is_a?(Integer); %(<li>#{link.call item}</li>)                                                       # page link
                elsif item.is_a?(String) ; %(<li class="current"><span class="show-for-sr">#{pagy_t('pagy.nav.current')}</span> #{item}</li>)  # active page
                elsif item == :gap       ; %(<li class="ellipsis" aria-hidden="true"></li>)                                    # page gap
                end
      end
      html << (p_next ? %(<li class="next">#{link.call p_next, pagy_t('pagy.nav.next'), 'aria-label="next"'}</li>)
                      : %(<li class="next disabled">#{pagy_t('pagy.nav.next')}</li>))
      %(<nav class="pagy-nav-foundation" role="navigation" aria-label="Pagination"><ul class="pagination">#{html}</ul></nav>)
    end

    # Compact pagination for Foundation: it returns the html with the series of links to the pages
    # we use a numeric input tag to set the page and the Pagy.compact javascript to navigate
    def pagy_nav_compact_foundation(pagy, id=caller(1,1)[0].hash)
      html, link, p_prev, p_next, p_page, p_pages = +'', pagy_link_proc(pagy), pagy.prev, pagy.next, pagy.page, pagy.pages

      html << %(<nav id="pagy-nav-#{id}" class="pagy-nav-compact-foundation" role="navigation" aria-label="Pagination">)
        html << link.call(MARKER, '', %(style="display: none;" ))
        (html << link.call(1, '', %(style="display: none;" ))) if defined?(TRIM)
        html << %(<div class="input-group">)
        html << (p_prev ? link.call(p_prev, pagy_t('pagy.nav.prev'), 'style="margin-bottom: 0px;" aria-label="previous" class="prev button primary"')
                        : %(<a style="margin-bottom: 0px;" class="prev button primary disabled" href="#">#{pagy_t('pagy.nav.prev')}</a>))
        input = %(<input class="input-group-field cell shrink" type="number" min="1" max="#{p_pages}" value="#{p_page}" style="width: #{p_pages.to_s.length+1.5}rem;">)
        html << %(<span class="input-group-label">#{pagy_t('pagy.compact.page')}</span> #{input} <span class="input-group-label">#{pagy_t('pagy.compact.of')} #{p_pages}</span>)
        html << (p_next ? link.call(p_next, pagy_t('pagy.nav.next'), 'style="margin-bottom: 0px;" aria-label="next" class="next button primary"')
                        : %(<a style="margin-bottom: 0px;" class="next button primary disabled" href="#">#{pagy_t('pagy.nav.next')}</a>))
      html << %(</div></nav><script type="application/json" class="pagy-compact-json">["#{id}", "#{MARKER}", "#{p_page}", #{!!defined?(TRIM)}]</script>)
    end

    # Responsive pagination for Foundation: it returns the html with the series of links to the pages
    # rendered by the Pagy.responsive javascript
    def pagy_nav_responsive_foundation(pagy, id=caller(1,1)[0].hash)
      tags, link, p_prev, p_next, responsive = {}, pagy_link_proc(pagy), pagy.prev, pagy.next, pagy.responsive

      tags['before'] = +'<ul class="pagination">'
      tags['before'] << (p_prev ? %(<li class="prev">#{link.call p_prev, pagy_t('pagy.nav.prev'), 'aria-label="previous"'}</li>)
                                : %(<li class="prev disabled">#{pagy_t('pagy.nav.prev')}</li>))
      responsive[:items].each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        tags[item.to_s] = if    item.is_a?(Integer); %(<li>#{link.call item}</li>)                              # page link
                          elsif item.is_a?(String) ; %(<li class="current"><span class="show-for-sr">#{pagy_t('pagy.nav.current')}</span> #{item}</li>)                        # active page
                          elsif item == :gap       ; %(<li class="gap disabled">#{pagy_t('pagy.nav.gap')}</li>) # page gap
                          end
      end
      tags['after'] = +(p_next ? %(<li class="next">#{link.call p_next, pagy_t('pagy.nav.next'), 'aria-label="next"'}</li>)
                               : %(<li class="next disabled">#{pagy_t('pagy.nav.next')}</li>))
      tags['after'] << '</ul>'
      script = %(<script type="application/json" class="pagy-responsive-json">["#{id}", #{tags.to_json},  #{responsive[:widths].to_json}, #{responsive[:series].to_json}]</script>)
      %(<nav id="pagy-nav-#{id}" class="pagy-nav-responsive-foundation" aria-label="Pagination"></nav>#{script})
    end

  end
end
