# See the Pagy Extras documentation: https://ddnexus.github.io/pagy/extras

class Pagy
  # Add nav helpers for compact pagination
  module Frontend

    # Generic compact pagination: it returns the html with the series of links to the pages
    # we use a numeric input tag to set the page and the PagyCompact javascript to navigate
    def pagy_nav_compact(pagy, id=caller(1,1)[0].hash)
      tags = ''; link = pagy_link_proc(pagy)

      tags << %(<nav id="pagy-nav-#{id}" class="pagy-nav-compact pagination" role="navigation" aria-label="pager">)

        tags << link.call(MARKER, '', %(style="display: none;" ))
        tags << (pagy.prev ? %(<span class="page prev">#{link.call pagy.prev, pagy_t('pagy.nav.prev'.freeze), 'aria-label="previous"'.freeze}</span> )
                           : %(<span class="page prev disabled">#{pagy_t('pagy.nav.prev'.freeze)}</span> ))

        input = %(<input type="number" min="1" max="#{pagy.last}" value="#{pagy.page}" style="padding: 0; text-align: center; width: #{pagy.pages.to_s.length+1}rem;">)
        tags << %(<span class="pagy-compact-input" style="margin: 0 0.6rem;">#{pagy_t('pagy.compact.page'.freeze)} #{input} #{pagy_t('pagy.compact.of'.freeze)} #{pagy.pages}</span> )

        tags << (pagy.next ? %(<span class="page next">#{link.call pagy.next, pagy_t('pagy.nav.next'.freeze), 'aria-label="next"'.freeze}</span>)
                           : %(<span class="page next disabled">#{pagy_t('pagy.nav.next'.freeze)}</span>))

      tags << %(</nav><script>PagyCompact('#{id}', '#{MARKER}', '#{pagy.page}');</script>)
    end

    # Compact pagination for bootstrap: it returns the html with the series of links to the pages
    # we use a numeric input tag to set the page and the PagyCompact javascript to navigate
    def pagy_nav_bootstrap_compact(pagy, id=caller(1,1)[0].hash)
      tags = ''; link = pagy_link_proc(pagy)

      tags << %(<nav id="pagy-nav-#{id}" class="pagy-nav-bootstrap-compact pagination" role="navigation" aria-label="pager">)

        tags << link.call(MARKER, '', %(style="display: none;" ))

        tags << %(<div class="btn-group" role="group">)
        tags << (pagy.prev ? link.call(pagy.prev, pagy_t('pagy.nav.prev'.freeze), 'aria-label="previous" class="prev btn btn-primary"'.freeze)
                           : %(<a class="prev btn btn-primary disabled" href="#">#{pagy_t('pagy.nav.prev'.freeze)}</a>))

        input = %(<input type="number" min="1" max="#{pagy.last}" value="#{pagy.page}" style="padding: 0; border: none; text-align: center; width: #{pagy.pages.to_s.length+1}rem;">)
        tags << %(<div class="pagy-compact-input btn btn-primary disabled">#{pagy_t('pagy.compact.page'.freeze)} #{input} #{pagy_t('pagy.compact.of'.freeze)} #{pagy.pages}</div>)

        tags << (pagy.next ? link.call(pagy.next, pagy_t('pagy.nav.next'.freeze), 'aria-label="next" class="next btn btn-primary"'.freeze)
                           : %(<a class="next btn btn-primary disabled" href="#">#{pagy_t('pagy.nav.next'.freeze)}</a>))

      tags << %(</div></nav><script>PagyCompact('#{id}', '#{MARKER}', '#{pagy.page}');</script>)
    end

  end
end

