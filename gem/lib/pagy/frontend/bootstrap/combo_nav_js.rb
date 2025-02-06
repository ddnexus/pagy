# frozen_string_literal: true

require_relative 'previous_next'
require_relative '../utils/combo_nav_js'

class Pagy
  Frontend.module_eval do
    # Javascript combo pagination for bootstrap: it returns a nav with a data-pagy attribute used by the pagy.js file
    def pagy_bootstrap_combo_nav_js(pagy, classes: 'pagination', **)
      anchor_lambda = pagy_anchor_lambda(pagy, **)
      pages = pagy.pages
      input = %(<input name="page" type="number" min="1" max="#{pages}" value="#{pagy.page}" aria-current="page" ) +
              %(style="text-align: center; width: #{pages.to_s.length + 1}rem; padding: 0; ) +
              %(border: none; display: inline-block;" class="page-link active">#{A_TAG})
      html  = %(<ul class="#{classes}">#{
                  pagy_bootstrap_html_for(:previous, pagy, anchor_lambda)
                }<li class="page-item pagy-bootstrap"><label class="page-link">#{
                  pagy_translate('pagy.combo_nav_js', page_input: input, pages:)
                }</label></li>#{
                  pagy_bootstrap_html_for(:next, pagy, anchor_lambda)
                }</ul>)
      ComboNavJs.tag(self, pagy, html, 'pagy-bootstrap combo-nav-js', **)
    end
  end
end
