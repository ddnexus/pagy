# frozen_string_literal: true

require_relative 'previous_next_html'
require_relative '../support/nav_js'

class Pagy
  private

  # Javascript pagination for bulma: it returns a nav with a data-pagy attribute used by the Pagy.nav javascript
  def bulma_nav_js_tag(classes: 'pagination is-centered', **)
    a_lambda = a_lambda(**)
    tokens   = { before:  %(#{bulma_previous_next_html(a_lambda)}<ul class="pagination-list">),
                 anchor:  %(<li>#{a_lambda.(PAGE_TOKEN, LABEL_TOKEN, classes: 'pagination-link')}</li>),
                 current: %(<li><a role="link" class="pagination-link is-current" ) +
                          %(aria-current="page" aria-disabled="true">#{LABEL_TOKEN}</a></li>),
                 gap:     %(<li><span class="pagination-ellipsis">#{I18n.translate('pagy.gap')}</span></li>),
                 after:   '</ul>' }
    wrap_nav_js(tokens, "pagy-bulma nav-js #{classes}", **)
  end
end
