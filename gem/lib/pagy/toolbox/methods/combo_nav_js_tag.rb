# frozen_string_literal: true

require_relative 'support/combo_nav_js'

class Pagy
  # Javascript combo pagination: it returns a nav with a data-pagy attribute used by the pagy.js file
  def combo_nav_js_tag(style = nil, **)
    return send(:"#{style}_combo_nav_js_tag", **) if style

    a_lambda = a_lambda(**)
    input    = %(<input name="page" type="number" min="1" max="#{@last}" value="#{@page}" aria-current="page" ) +
               %(style="text-align: center; width: #{@last.to_s.length + 1}rem; padding: 0;">#{A_TAG})
    html     = %(#{previous_tag(a_lambda)}<label>#{
                 I18n.translate('pagy.combo_nav_js_tag', page_input: input, pages: @last)}</label>#{
                 next_tag(a_lambda)})
    wrap_combo_nav_js(html, 'pagy combo-nav-js', **)
  end
end
