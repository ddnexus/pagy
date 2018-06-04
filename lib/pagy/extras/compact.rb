# See the Pagy Extras documentation: https://ddnexus.github.io/pagy/extras

class Pagy
  # Add nav helpers for compact pagination
  module Frontend

    # Generic compact pagination: it returns the html with the series of links to the pages
    # we use a numeric input tag to set the page and the PagyCompact javascript to navigate
    def pagy_nav_compact(pagy, id=caller(1,1)[0].hash)
      tags, link, p_prev, p_next, p_page, p_pages = '', pagy_link_proc(pagy), pagy.prev, pagy.next, pagy.page, pagy.pages

      tags << %(<nav id="pagy-nav-#{id}" class="pagy-nav-compact pagination" role="navigation" aria-label="pager">)

        tags << link.call(MARKER, '', %(style="display: none;" ))
        tags << (p_prev ? %(<span class="page prev">#{link.call p_prev, pagy_t('pagy.nav.prev'.freeze), 'aria-label="previous"'.freeze}</span> )
                        : %(<span class="page prev disabled">#{pagy_t('pagy.nav.prev'.freeze)}</span> ))

        input = %(<input type="number" min="1" max="#{p_pages}" value="#{p_page}" style="padding: 0; text-align: center; width: #{p_pages.to_s.length+1}rem;">)
        tags << %(<span class="pagy-compact-input" style="margin: 0 0.6rem;">#{pagy_t('pagy.compact.page'.freeze)} #{input} #{pagy_t('pagy.compact.of'.freeze)} #{p_pages}</span> )

        tags << (p_next ? %(<span class="page next">#{link.call p_next, pagy_t('pagy.nav.next'.freeze), 'aria-label="next"'.freeze}</span>)
                        : %(<span class="page next disabled">#{pagy_t('pagy.nav.next'.freeze)}</span>))

      tags << %(</nav><script>PagyCompact('#{id}', '#{MARKER}', '#{p_page}');</script>)
    end

    # Compact pagination for bootstrap: it returns the html with the series of links to the pages
    # we use a numeric input tag to set the page and the PagyCompact javascript to navigate
    def pagy_nav_bootstrap_compact(pagy, id=caller(1,1)[0].hash)
      tags, link, p_prev, p_next, p_page, p_pages = '', pagy_link_proc(pagy), pagy.prev, pagy.next, pagy.page, pagy.pages

      tags << %(<nav id="pagy-nav-#{id}" class="pagy-nav-bootstrap-compact pagination" role="navigation" aria-label="pager">)

        tags << link.call(MARKER, '', %(style="display: none;" ))

        tags << %(<div class="btn-group" role="group">)
        tags << (p_prev ? link.call(p_prev, pagy_t('pagy.nav.prev'.freeze), 'aria-label="previous" class="prev btn btn-primary"'.freeze)
                        : %(<a class="prev btn btn-primary disabled" href="#">#{pagy_t('pagy.nav.prev'.freeze)}</a>))

        input = %(<input type="number" min="1" max="#{p_pages}" value="#{p_page}" style="padding: 0; border: none; text-align: center; width: #{p_pages.to_s.length+1}rem;">)
        tags << %(<div class="pagy-compact-input btn btn-primary disabled">#{pagy_t('pagy.compact.page'.freeze)} #{input} #{pagy_t('pagy.compact.of'.freeze)} #{p_pages}</div>)

        tags << (p_next ? link.call(p_next, pagy_t('pagy.nav.next'.freeze), 'aria-label="next" class="next btn btn-primary"'.freeze)
                        : %(<a class="next btn btn-primary disabled" href="#">#{pagy_t('pagy.nav.next'.freeze)}</a>))

      tags << %(</div></nav><script>PagyCompact('#{id}', '#{MARKER}', '#{p_page}');</script>)
    end

  end
end

