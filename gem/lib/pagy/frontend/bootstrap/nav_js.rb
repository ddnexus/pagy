# frozen_string_literal: true

require_relative 'previous_next'
require_relative '../utils/nav_js'

class Pagy
  Frontend.module_eval do
    # Javascript pagination for bootstrap: it returns a nav with a data-pagy attribute used by the pagy.js file
    def pagy_bootstrap_nav_js(pagy, classes: 'pagination', **)
      create_anchor = pagy_create_anchor_lambda(pagy, **)
      tokens = { before:  %(<ul class="#{classes}">#{pagy_bootstrap_html_for(:previous, pagy, create_anchor)}),
                 anchor:  %(<li class="page-item">#{create_anchor.(PAGE_TOKEN, LABEL_TOKEN, classes: 'page-link')}</li>),
                 current: %(<li class="page-item active"><a role="link" class="page-link" ) +
                          %(aria-current="page" aria-disabled="true">#{LABEL_TOKEN}</a></li>),
                 gap:     %(<li class="page-item gap disabled"><a role="link" class="page-link" aria-disabled="true">#{
                              pagy_translate('pagy.gap')}</a></li>),
                 after:   %(#{pagy_bootstrap_html_for(:next, pagy, create_anchor)}</ul>) }
      NavJs.tag(self, pagy, tokens, 'pagy-bootstrap nav-js', **)
    end
  end
end
