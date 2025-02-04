# frozen_string_literal: true

require_relative '../utils/combo_nav_js'

class Pagy
  Frontend.module_eval do
    # Javascript combo pagination: it returns a nav with a data-pagy attribute used by the pagy.js file
    def pagy_combo_nav_js(pagy, **)
      create_anchor = pagy_create_anchor_lambda(pagy, **)
      pages = pagy.pages
      input = %(<input name="page" type="number" min="1" max="#{pages}" value="#{pagy.page}" aria-current="page" ) +
              %(style="text-align: center; width: #{pages.to_s.length + 1}rem; padding: 0;">#{A_TAG})
      html  = %(#{pagy_previous_a(pagy, create_anchor)}<label>#{
                  pagy_translate('pagy.combo_nav_js', page_input: input, pages:)}</label>#{
                  pagy_next_a(pagy, create_anchor)})
      ComboNavJs.tag(self, pagy, html, 'pagy combo-nav-js', **)
    end
  end
end
