# frozen_string_literal: true

require_relative 'previous_next_html'
require_relative '../support/wrap_input_nav_js'

class Pagy
  private

  # Javascript combo pagination for bulma: it returns a nav with a data-pagy attribute used by the pagy.js file
  def bulma_input_nav_js(classes: 'pagination', **)
    a_lambda = a_lambda(**)
    input    = %(<input name="page" type="number" min="1" max="#{@last}" value="#{@page}" aria-current="page") +
               %(style="text-align: center; width: #{@last.to_s.length + 1}rem; height: 1.7rem; margin:0 0.3rem; ) +
               %(border: none; border-radius: 4px; padding: 0; font-size: 1.1rem; color: white; ) +
               %(background-color: #485fc7;">#{A_TAG})
    html     = %(<ul class="pagination-list">#{bulma_html_for(:previous, a_lambda)}<li class="pagination-link"><label>#{
                 I18n.translate('pagy.input_nav_js', page_input: input, pages: @last)
                 }</label></li>#{bulma_html_for(:next, a_lambda)}</ul>)
    wrap_input_nav_js(html, "pagy-bulma input-nav-js #{classes}", **)
  end
end
