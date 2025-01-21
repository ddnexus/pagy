# frozen_string_literal: true

require_relative 'prev_next'

class Pagy
  Frontend.module_eval do
    # Javascript pagination: it returns a nav with a data-pagy attribute used by the pagy.js file
    def pagy_nav_js(pagy, **vars)
      a      = pagy_anchor(pagy, **vars)
      tokens = { before:  pagy_prev_a(pagy, a),
                 anchor:  a.(PAGE_TOKEN, LABEL_TOKEN),
                 current: %(<a class="current" role="link" aria-current="page" aria-disabled="true">#{LABEL_TOKEN}</a>),
                 gap:     %(<a class="gap" role="link" aria-disabled="true">#{pagy_t('pagy.gap')}</a>),
                 after:   pagy_next_a(pagy, a) }
      Front.build_nav_js(self, pagy, tokens, 'pagy nav-js', **vars)
    end
  end
end
