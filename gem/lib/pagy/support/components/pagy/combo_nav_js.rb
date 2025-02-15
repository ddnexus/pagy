# frozen_string_literal: true

require_relative '../utils/combo_nav_js_tag'

class Pagy
  # Javascript combo pagination: it returns a nav with a data-pagy attribute used by the pagy.js file
  def combo_nav_js(style: nil, **)
    if style
      require_relative "../#{style}/combo_nav_js"
      return send(:"#{style}_combo_nav_js", **)
    end

    anchor_lambda = anchor_lambda(**)
    input = %(<input name="page" type="number" min="1" max="#{@last}" value="#{@page}" aria-current="page" ) +
            %(style="text-align: center; width: #{@last.to_s.length + 1}rem; padding: 0;">#{A_TAG})
    html  = %(#{previous_anchor(anchor_lambda)}<label>#{
                I18n.translate('pagy.combo_nav_js', page_input: input, pages: @last)}</label>#{
                next_anchor(anchor_lambda)})
    combo_nav_js_tag(html, 'pagy combo-nav-js', **)
  end
end
