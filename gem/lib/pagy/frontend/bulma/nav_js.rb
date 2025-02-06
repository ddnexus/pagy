# frozen_string_literal: true

require_relative 'previous_next'
require_relative '../utils/nav_js'

class Pagy
  Frontend.module_eval do
    # Javascript pagination for bulma: it returns a nav with a data-pagy attribute used by the Pagy.nav javascript
    def pagy_bulma_nav_js(pagy, classes: 'pagination is-centered', **)
      anchor_lambda = pagy_anchor_lambda(pagy, **)
      tokens = { before:  %(#{bulma_previous_next_html(pagy, anchor_lambda)}<ul class="pagination-list">),
                 anchor:  %(<li>#{anchor_lambda.(PAGE_TOKEN, LABEL_TOKEN, classes: 'pagination-link')}</li>),
                 current: %(<li><a role="link" class="pagination-link is-current" ) +
                          %(aria-current="page" aria-disabled="true">#{LABEL_TOKEN}</a></li>),
                 gap:     %(<li><span class="pagination-ellipsis">#{pagy_translate('pagy.gap')}</span></li>),
                 after:   '</ul>' }
      NavJs.tag(self, pagy, tokens, "pagy-bulma nav-js #{classes}", **)
    end
  end
end
