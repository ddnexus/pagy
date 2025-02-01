# frozen_string_literal: true

require_relative 'previous_next'
require_relative '../utils/nav_js'

class Pagy
  Frontend.module_eval do
    # Return a nav with a data-pagy attribute used by the pagy.js file
    def pagy_nav_js(pagy, **)
      a      = pagy_anchor(pagy, **)
      tokens = { before:  pagy_previous_a(pagy, a),
                 anchor:  a.(PAGE_TOKEN, LABEL_TOKEN),
                 current: %(<a class="current" role="link" aria-current="page" aria-disabled="true">#{LABEL_TOKEN}</a>),
                 gap:     %(<a class="gap" role="link" aria-disabled="true">#{pagy_translate('pagy.gap')}</a>),
                 after:   pagy_next_a(pagy, a) }
      NavJs.tag(self, pagy, tokens, 'pagy nav-js', **)
    end
  end
end
