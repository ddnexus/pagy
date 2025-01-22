# frozen_string_literal: true

require_relative 'nav_aria_label'
require_relative 'data_pagy'

class Pagy
  # Relegate internal functions. Make overriding navs easier.
  module ComboNavJs
    module_function

    # Build the nav_js tag, with the specific inner html for the style
    def tag(frontend, pagy, html, nav_classes, id: nil, aria_label: nil, **vars)
      %(<nav#{%( id="#{id}") if id} class="#{nav_classes}" #{
        NavAriaLabel.attr(frontend, pagy, aria_label:)} #{
        DataPagy.attr(:cj, frontend.pagy_page_url(pagy, PAGE_TOKEN, **vars))
      }>#{html}</nav>)
    end
  end
end
