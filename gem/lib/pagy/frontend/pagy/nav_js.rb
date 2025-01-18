# frozen_string_literal: true

class Pagy
  Frontend.module_eval do
    # Javascript pagination: it returns a nav with a data-pagy attribute used by the pagy.js file
    def pagy_nav_js(pagy, id: nil, aria_label: nil, **vars)
      sequels = pagy.sequels(**vars)
      id      = %( id="#{id}") if id
      a       = pagy_anchor(pagy, **vars)
      tokens  = { before:  pagy_prev_a(pagy, a),
                  anchor:  a.(PAGE_TOKEN, LABEL_TOKEN),
                  current: %(<a class="current" role="link" aria-current="page" aria-disabled="true">#{LABEL_TOKEN}</a>),
                  gap:     %(<a class="gap" role="link" aria-disabled="true">#{pagy_t('pagy.gap')}</a>),
                  after:   pagy_next_a(pagy, a) }
      %(<nav#{id} class="#{'pagy-rjs ' if sequels[0].size > 1}pagy nav-js" #{
          pagy_nav_aria_label(pagy, aria_label:)} #{
          pagy_data(pagy, :nj, tokens.values, *sequels)
        }></nav>)
    end
  end
end
