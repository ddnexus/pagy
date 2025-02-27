# frozen_string_literal: true

require_relative 'previous_next_html'
require_relative '../support/combo_nav_js'

class Pagy
  private

  # Javascript combo pagination for bulma: it returns a nav with a data-pagy attribute used by the pagy.js file
  def bulma_combo_nav_js_tag(classes: 'pagination is-centered', **)
    a_lambda = a_lambda(**)
    input    = %(<input name="page" type="number" min="1" max="#{@last}" value="#{@page}" aria-current="page") +
               %(style="text-align: center; width: #{@last.to_s.length + 1}rem; height: 1.7rem; margin:0 0.3rem; ) +
               %(border: none; border-radius: 4px; padding: 0; font-size: 1.1rem; color: white; ) +
               %(background-color: #485fc7;">#{A_TAG})
    html     = %(#{bulma_previous_next_html(a_lambda)
                 }<ul class="pagination-list"><li class="pagination-link"><label>#{
                 I18n.translate('pagy.combo_nav_js_tag', page_input: input, pages: @last)
                 }</label></li></ul>)
    wrap_combo_nav_js(html, "pagy-bulma combo-nav-js #{classes}", **)
  end
end
