# frozen_string_literal: true

require_relative 'utils/wrap_nav_js'

class Pagy
  # Return a nav with a data-pagy attribute used by the pagy.js file
  def nav_js_tag(style: nil, **)
    if style
      require_relative "#{style}/nav_js_tag"
      return send(:"#{style}_nav_js_tag", **)
    end

    a_lambda = a_lambda(**)
    tokens   = { before:  previous_a_tag(a_lambda),
                 anchor:  a_lambda.(PAGE_TOKEN, LABEL_TOKEN),
                 current: %(<a class="current" role="link" aria-current="page" aria-disabled="true">#{LABEL_TOKEN}</a>),
                 gap:     %(<a class="gap" role="link" aria-disabled="true">#{I18n.translate('pagy.gap')}</a>),
                 after:   next_a_tag(a_lambda) }
    wrap_nav_js(tokens, 'pagy nav-js', **)
  end
end
