# frozen_string_literal: true

require_relative 'previous_next'
require_relative '../utils/combo_nav_js'

class Pagy
  Frontend.module_eval do
    # Javascript combo pagination for bulma: it returns a nav with a data-pagy attribute used by the pagy.js file
    def pagy_bulma_combo_nav_js(pagy, classes: 'pagination is-centered', **)
      anchor_lambda = pagy_anchor_lambda(pagy, **)
      pages = pagy.pages
      input = %(<input name="page" type="number" min="1" max="#{pages}" value="#{pagy.page}" aria-current="page") +
              %(style="text-align: center; width: #{pages.to_s.length + 1}rem; height: 1.7rem; margin:0 0.3rem; ) +
              %(border: none; border-radius: 4px; padding: 0; font-size: 1.1rem; color: white; ) +
              %(background-color: #485fc7;">#{A_TAG})
      html  = %(#{bulma_previous_next_html(pagy, anchor_lambda)
                }<ul class="pagination-list"><li class="pagination-link"><label>#{
                  pagy_translate('pagy.combo_nav_js', page_input: input, pages:)
                }</label></li></ul>)
      ComboNavJs.tag(self, pagy, html, "pagy-bulma combo-nav-js #{classes}", **)
    end
  end
end
