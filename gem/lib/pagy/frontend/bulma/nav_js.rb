# frozen_string_literal: true

require_relative 'prev_next'

class Pagy
  Frontend.module_eval do
    # Javascript pagination for bulma: it returns a nav with a data-pagy attribute used by the Pagy.nav javascript
    def pagy_bulma_nav_js(pagy, id: nil, classes: 'pagy-bulma nav-js pagination is-centered',
                          aria_label: nil, **vars)
      sequels = pagy.sequels(**vars)
      id      = %( id="#{id}") if id
      a       = pagy_anchor(pagy, **vars)
      tokens = { before:  %(#{bulma_prev_next_html(pagy, a)}<ul class="pagination-list">),
                 anchor:  %(<li>#{a.(PAGE_TOKEN, LABEL_TOKEN, classes: 'pagination-link')}</li>),
                 current: %(<li><a role="link" class="pagination-link is-current" ) +
                          %(aria-current="page" aria-disabled="true">#{LABEL_TOKEN}</a></li>),
                 gap:     %(<li><span class="pagination-ellipsis">#{pagy_t 'pagy.gap'}</span></li>),
                 after:   '</ul>' }

      %(<nav#{id} class="#{'pagy-rjs ' if sequels[0].size > 1}#{classes}" #{
          pagy_nav_aria_label(pagy, aria_label:)} #{
          pagy_data(pagy, :nj, tokens.values, *sequels)
        }></nav>)
    end
  end
end
