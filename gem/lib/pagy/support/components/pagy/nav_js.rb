# frozen_string_literal: true

require_relative '../utils/nav_js_tag'

class Pagy
  # Return a nav with a data-pagy attribute used by the pagy.js file
  def nav_js(style: nil, **)
    if style
      require_relative "../#{style}/nav_js"
      return send(:"#{style}_nav_js", **)
    end

    anchor_lambda = anchor_lambda(**)
    tokens = { before:  previous_anchor(anchor_lambda),
               anchor:  anchor_lambda.(PAGE_TOKEN, LABEL_TOKEN),
               current: %(<a class="current" role="link" aria-current="page" aria-disabled="true">#{LABEL_TOKEN}</a>),
               gap:     %(<a class="gap" role="link" aria-disabled="true">#{I18n.translate('pagy.gap')}</a>),
               after:   next_anchor(anchor_lambda) }
    nav_js_tag(tokens, 'pagy nav-js', **)
  end
end
