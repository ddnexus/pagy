# frozen_string_literal: true

require_relative 'previous_next'
require_relative '../utils/nav_js_tag'

class Pagy
  private

  # Javascript pagination for bootstrap: it returns a nav with a data-pagy attribute used by the pagy.js file
  def bootstrap_nav_js(classes: 'pagination', **)
    anchor_lambda = anchor_lambda(**)
    tokens = { before:  %(<ul class="#{classes}">#{bootstrap_html_for(:previous, anchor_lambda)}),
               anchor:  %(<li class="page-item">#{anchor_lambda.(PAGE_TOKEN, LABEL_TOKEN, classes: 'page-link')}</li>),
               current: %(<li class="page-item active"><a role="link" class="page-link" ) +
                        %(aria-current="page" aria-disabled="true">#{LABEL_TOKEN}</a></li>),
               gap:     %(<li class="page-item gap disabled"><a role="link" class="page-link" aria-disabled="true">#{
                          I18n.translate('pagy.gap')}</a></li>),
               after:   %(#{bootstrap_html_for(:next, anchor_lambda)}</ul>) }
    nav_js_tag(tokens, 'pagy-bootstrap nav-js', **)
  end
end
