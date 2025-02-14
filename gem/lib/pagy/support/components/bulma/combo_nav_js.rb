# frozen_string_literal: true

require_relative 'previous_next'
require_relative '../utils/combo_nav_js_tag'

class Pagy
  class_eval do
    # Javascript combo pagination for bulma: it returns a nav with a data-pagy attribute used by the pagy.js file
    def bulma_combo_nav_js(classes: 'pagination is-centered', **)
      anchor_lambda = anchor_lambda(**)
      input = %(<input name="page" type="number" min="1" max="#{@last}" value="#{@page}" aria-current="page") +
              %(style="text-align: center; width: #{@last.to_s.length + 1}rem; height: 1.7rem; margin:0 0.3rem; ) +
              %(border: none; border-radius: 4px; padding: 0; font-size: 1.1rem; color: white; ) +
              %(background-color: #485fc7;">#{A_TAG})
      html  = %(#{bulma_previous_next_html(anchor_lambda)
                }<ul class="pagination-list"><li class="pagination-link"><label>#{
                  I18n.translate('pagy.combo_nav_js', page_input: input, pages: @last)
                }</label></li></ul>)
      combo_nav_js_tag(html, "pagy-bulma combo-nav-js #{classes}", **)
    end
  end
end
