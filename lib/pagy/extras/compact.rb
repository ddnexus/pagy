# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/compact
# frozen_string_literal: true

class Pagy
  # Add nav helpers for compact pagination
  module Frontend

    # Generic compact pagination: it returns the html with the series of links to the pages
    # we use a numeric input tag to set the page and the Pagy.compact javascript to navigate
    def pagy_nav_compact(pagy, id=caller(1,1)[0].hash)
      html, link, p_prev, p_next, p_page, p_pages = +'', pagy_link_proc(pagy), pagy.prev, pagy.next, pagy.page, pagy.pages

      html << %(<nav id="pagy-nav-#{id}" class="pagy-nav-compact pagination" role="navigation" aria-label="pager">)
        html << link.call(MARKER, '', %(style="display: none;" ))
        (html << link.call(1, '', %(style="display: none;" ))) if defined?(TRIM)
      html << (p_prev ? %(<span class="page prev">#{link.call p_prev, pagy_t('pagy.nav.prev'), 'aria-label="previous"'}</span> )
                        : %(<span class="page prev disabled">#{pagy_t('pagy.nav.prev')}</span> ))
        input = %(<input type="number" min="1" max="#{p_pages}" value="#{p_page}" style="padding: 0; text-align: center; width: #{p_pages.to_s.length+1}rem;">)
        html << %(<span class="pagy-compact-input" style="margin: 0 0.6rem;">#{pagy_t('pagy.compact.page')} #{input} #{pagy_t('pagy.compact.of')} #{p_pages}</span> )
        html << (p_next ? %(<span class="page next">#{link.call p_next, pagy_t('pagy.nav.next'), 'aria-label="next"'}</span>)
                        : %(<span class="page next disabled">#{pagy_t('pagy.nav.next')}</span>))
      html << %(</nav><script type="application/json" class="pagy-compact-json">["#{id}", "#{MARKER}", "#{p_page}", #{!!defined?(TRIM)}]</script>)
    end

    # Compact pagination for bootstrap: it returns the html with the series of links to the pages
    # we use a numeric input tag to set the page and the Pagy.compact javascript to navigate
    def pagy_nav_compact_bootstrap(pagy, id=caller(1,1)[0].hash)
      html, link, p_prev, p_next, p_page, p_pages = +'', pagy_link_proc(pagy), pagy.prev, pagy.next, pagy.page, pagy.pages

      html << %(<nav id="pagy-nav-#{id}" class="pagy-nav-compact-bootstrap pagination" role="navigation" aria-label="pager">)
        html << link.call(MARKER, '', %(style="display: none;" ))
        (html << link.call(1, '', %(style="display: none;" ))) if defined?(TRIM)
      html << %(<div class="btn-group" role="group">)
        html << (p_prev ? link.call(p_prev, pagy_t('pagy.nav.prev'), 'aria-label="previous" class="prev btn btn-primary"')
                        : %(<a class="prev btn btn-primary disabled" href="#">#{pagy_t('pagy.nav.prev')}</a>))
        input = %(<input type="number" min="1" max="#{p_pages}" value="#{p_page}" style="padding: 0; border: none; text-align: center; width: #{p_pages.to_s.length+1}rem;">)
        html << %(<div class="pagy-compact-input btn btn-primary disabled">#{pagy_t('pagy.compact.page')} #{input} #{pagy_t('pagy.compact.of')} #{p_pages}</div>)
        html << (p_next ? link.call(p_next, pagy_t('pagy.nav.next'), 'aria-label="next" class="next btn btn-primary"')
                        : %(<a class="next btn btn-primary disabled" href="#">#{pagy_t('pagy.nav.next')}</a>))
      html << %(</div></nav><script type="application/json" class="pagy-compact-json">["#{id}", "#{MARKER}", "#{p_page}", #{!!defined?(TRIM)}]</script>)
    end

    # Compact pagination for Bulma: it returns the html with the series of links to the pages
    # we use a numeric input tag to set the page and the Pagy.compact javascript to navigate
    def pagy_nav_compact_bulma(pagy, id=caller(1,1)[0].hash)
      html, link, p_prev, p_next, p_page, p_pages = +'', pagy_link_proc(pagy), pagy.prev, pagy.next, pagy.page, pagy.pages

      html << %(<nav id="pagy-nav-#{id}" class="pagy-nav-compact-bulma" role="navigation" aria-label="pagination">)
        html << link.call(MARKER, '', 'style="display: none;"')
        (html << link.call(1, '', %(style="display: none;"))) if defined?(TRIM)
        html << %(<div class="field is-grouped is-grouped-centered" role="group">)
        html << (p_prev ? %(<p class="control">#{link.call(p_prev, pagy_t('pagy.nav.prev'), 'class="button" aria-label="previous page"')}</p>)
                        : %(<p class="control"><a class="button" disabled>#{pagy_t('pagy.nav.prev')}</a></p>))
        input = %(<input class="input" type="number" min="1" max="#{p_pages}" value="#{p_page}" style="padding: 0; text-align: center; width: #{p_pages.to_s.length+1}rem;">)
        html << %(<div class="pagy-compact-input control level is-mobile">#{pagy_t('pagy.compact.page')}&nbsp;#{input}&nbsp;#{pagy_t('pagy.compact.of')} #{p_pages}</div>)
        html << (p_next ? %(<p class="control">#{link.call(p_next, pagy_t('pagy.nav.next'), 'class="button" aria-label="next page"')}</p>)
                        : %(<p class="control"><a class="button" disabled>#{pagy_t('pagy.nav.next')}</a></p>))
      html << %(</div></nav><script type="application/json" class="pagy-compact-json">["#{id}", "#{MARKER}", "#{p_page}", #{!!defined?(TRIM)}]</script>)
    end

    # Compact pagination for foundation: it returns the html with the series of links to the pages
    # we use a numeric input tag to set the page and the Pagy.compact javascript to navigate
    def pagy_nav_compact_foundation(pagy, id=caller(1,1)[0].hash)
      html, link, p_prev, p_next, p_page, p_pages = +'', pagy_link_proc(pagy), pagy.prev, pagy.next, pagy.page, pagy.pages

      html << %(<nav id="pagy-nav-#{id}" class="pagy-nav-compact-foundation" aria-label="Pagination">)
        html << link.call(MARKER, '', %(style="display: none;" ))
        (html << link.call(1, '', %(style="display: none;" ))) if defined?(TRIM)
      html << %(<div class="button-group">)
        html << (p_prev ? link.call(p_prev, pagy_t('pagy.nav.prev'), 'aria-label="previous" class="button primary"')
                        : %(<a class="button primary disabled" href="#">#{pagy_t('pagy.nav.prev')}</a>))
        input = %(<input type="number" min="1" max="#{p_pages}" value="#{p_page}" style="padding: 0; border: none; text-align: center; width: #{p_pages.to_s.length+1}rem;">)
        html << %(<span class="pagy-compact-input hollow button">#{pagy_t('pagy.compact.page')} #{input} #{pagy_t('pagy.compact.of')} #{p_pages}</span>)
        html << (p_next ? link.call(p_next, pagy_t('pagy.nav.next'), 'aria-label="next" class="button primary"')
                        : %(<a class="button primary disabled" href="#">#{pagy_t('pagy.nav.next')}</a>))
      html << %(</div></nav><script type="application/json" class="pagy-compact-json">["#{id}", "#{MARKER}", "#{p_page}", #{!!defined?(TRIM)}]</script>)
    end

    # Compact pagination for materialize: it returns the html with the series of links to the pages
    # we use a numeric input tag to set the page and the Pagy.compact javascript to navigate
    def pagy_nav_compact_materialize(pagy, id=caller(1,1)[0].hash)
      html, link, p_prev, p_next, p_page, p_pages = +'', pagy_link_proc(pagy), pagy.prev, pagy.next, pagy.page, pagy.pages

      html << %(<div id="pagy-nav-#{id}" class="pagy-nav-compact-materialize pagination" role="navigation" aria-label="pager">)
      html << link.call(MARKER, '', %(style="display: none;" ))
      (html << link.call(1, '', %(style="display: none;" ))) if defined?(TRIM)
      html << %(<div class="pagy-compact-chip role="group" style="height: 35px; border-radius: 18px; background: #e4e4e4; display: inline-block;">)
      html << '<ul class="pagination" style="margin: 0px;">'
      li_style = 'style="vertical-align: middle;"'
      html << (p_prev ? %(<li class="waves-effect prev" #{li_style}>#{link.call p_prev, '<i class="material-icons">chevron_left</i>', 'aria-label="previous"'}</li>)
                      : %(<li class="prev disabled" #{li_style}><a href="#"><i class="material-icons">chevron_left</i></a></li>))
      input = %(<input type="number" class="browser-default" min="1" max="#{p_pages}" value="#{p_page}" style="padding: 2px; border: none; border-radius: 2px; text-align: center; width: #{p_pages.to_s.length+1}rem;">)
      html << %(<div class="pagy-compact-input btn-flat" style="cursor: default; padding: 0px">#{pagy_t('pagy.compact.page')} #{input} #{pagy_t('pagy.compact.of')} #{p_pages}</div>)
      html << (p_next ? %(<li class="waves-effect next" #{li_style}>#{link.call p_next, '<i class="material-icons">chevron_right</i>', 'aria-label="next"'}</li>)
                      : %(<li class="next disabled" #{li_style}><a href="#"><i class="material-icons">chevron_right</i></a></li>))
      html << %(</ul></div><script type="application/json" class="pagy-compact-json">["#{id}", "#{MARKER}", "#{p_page}", #{!!defined?(TRIM)}]</script>)
    end

  end
end
