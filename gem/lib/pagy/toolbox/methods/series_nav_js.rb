# frozen_string_literal: true

require_relative 'support/wrap_series_nav_js'

class Pagy
  # Return a nav with a data-pagy attribute used by the pagy.js file
  def series_nav_js(style = nil, **)
    return send(:"#{style}_series_nav_js", **) if style

    a_lambda = a_lambda(**)
    tokens   = { before:  previous_tag(a_lambda),
                 anchor:  a_lambda.(PAGE_TOKEN, LABEL_TOKEN),
                 current: %(<a class="current" role="link" aria-current="page" aria-disabled="true">#{LABEL_TOKEN}</a>),
                 gap:     %(<a class="gap" role="link" aria-disabled="true">#{I18n.translate('pagy.gap')}</a>),
                 after:   next_tag(a_lambda) }
    wrap_series_nav_js(tokens, 'pagy series-nav-js', **)
  end
end
