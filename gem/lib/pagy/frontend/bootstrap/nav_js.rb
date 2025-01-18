# frozen_string_literal: true

require_relative 'prev_next'

class Pagy
  Frontend.module_eval do
    # Javascript pagination for bootstrap: it returns a nav with a data-pagy attribute used by the pagy.js file
    def pagy_bootstrap_nav_js(pagy, id: nil, classes: 'pagination', aria_label: nil, **vars)
      sequels = pagy.sequels(**vars)
      id      = %( id="#{id}") if id
      a       = pagy_anchor(pagy, **vars)
      tokens  = { before:  %(<ul class="#{classes}">#{bootstrap_prev_html(pagy, a)}),
                  anchor:  %(<li class="page-item">#{a.(PAGE_TOKEN, LABEL_TOKEN, classes: 'page-link')}</li>),
                  current: %(<li class="page-item active"><a role="link" class="page-link" ) +
                           %(aria-current="page" aria-disabled="true">#{LABEL_TOKEN}</a></li>),
                  gap:     %(<li class="page-item gap disabled"><a role="link" class="page-link" aria-disabled="true">#{
                               pagy_t('pagy.gap')}</a></li>),
                  after:   %(#{bootstrap_next_html pagy, a}</ul>) }

      %(<nav#{id} class="#{'pagy-rjs ' if sequels[0].size > 1}pagy-bootstrap nav-js" #{
          pagy_nav_aria_label(pagy, aria_label:)} #{
          pagy_data(pagy, :nj, tokens.values, *sequels)
        }></nav>)
    end
  end
end
