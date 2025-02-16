# frozen_string_literal: true

require_relative 'previous_next_html'
require_relative '../utils/wrap_combo_nav_js'

class Pagy
  private

  # Javascript combo pagination for bootstrap: it returns a nav with a data-pagy attribute used by the pagy.js file
  def bootstrap_combo_nav_js_tag(classes: 'pagination', **)
    a_lambda = a_lambda(**)
    input    = %(<input name="page" type="number" min="1" max="#{pages}" value="#{@page}" aria-current="page" ) +
               %(style="text-align: center; width: #{pages.to_s.length + 1}rem; padding: 0; ) +
               %(border: none; display: inline-block;" class="page-link active">#{A_TAG})
    html     = %(<ul class="#{classes}">#{
                   bootstrap_html_for(:previous, a_lambda)
                 }<li class="page-item pagy-bootstrap"><label class="page-link">#{
                   I18n.translate('pagy.combo_nav_js_tag', page_input: input, pages: @last)
                 }</label></li>#{
                   bootstrap_html_for(:next, a_lambda)
                 }</ul>)
    wrap_combo_nav_js(html, 'pagy-bootstrap combo-nav-js', **)
  end
end
