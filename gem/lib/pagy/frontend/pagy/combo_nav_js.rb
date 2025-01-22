# frozen_string_literal: true

require_relative '../utils/combo_nav_js'

class Pagy
  Frontend.module_eval do
    # Javascript combo pagination: it returns a nav with a data-pagy attribute used by the pagy.js file
    def pagy_combo_nav_js(pagy, **vars)
      a     = pagy_anchor(pagy, **vars)
      pages = pagy.pages
      input = %(<input name="page" type="number" min="1" max="#{pages}" value="#{pagy.page}" aria-current="page" ) +
              %(style="text-align: center; width: #{pages.to_s.length + 1}rem; padding: 0;">#{A_TAG})
      html  = %(#{pagy_prev_a(pagy, a)}<label>#{pagy_t('pagy.combo_nav_js', page_input: input, pages:)}</label>#{
                pagy_next_a(pagy, a)})
      ComboNavJs.tag(self, pagy, html, 'pagy combo-nav-js', **vars)
    end
  end
end
