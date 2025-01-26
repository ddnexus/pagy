# frozen_string_literal: true

require_relative 'prev_next'
require_relative '../utils/combo_nav_js'

class Pagy
  Frontend.module_eval do
    # Javascript combo pagination for bootstrap: it returns a nav with a data-pagy attribute used by the pagy.js file
    def pagy_bootstrap_combo_nav_js(pagy, classes: 'pagination', **)
      a     = pagy_anchor(pagy, **)
      pages = pagy.pages
      input = %(<input name="page" type="number" min="1" max="#{pages}" value="#{pagy.page}" aria-current="page" ) +
              %(style="text-align: center; width: #{pages.to_s.length + 1}rem; padding: 0; ) +
              %(border: none; display: inline-block;" class="page-link active">#{A_TAG})
      html  = %(<ul class="#{classes}">#{
                  bootstrap_prev_html(pagy, a)
                }<li class="page-item pagy-bootstrap"><label class="page-link">#{
                  pagy_t('pagy.combo_nav_js', page_input: input, pages:)
                }</label></li>#{
                  bootstrap_next_html(pagy, a)
                }</ul>)
      ComboNavJs.tag(self, pagy, html, 'pagy-bootstrap combo-nav-js', **)
    end
  end
end
