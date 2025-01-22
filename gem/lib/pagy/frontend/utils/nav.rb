# frozen_string_literal: true

require_relative 'nav_aria_label'
require_relative 'data_pagy'

class Pagy
  # Relegate internal functions. Make overriding navs easier.
  module Nav
    module_function

    # Build the nav_js tag, with the specific inner html for the style
    def tag(frontend, pagy, html, nav_classes, id: nil, aria_label: nil, **_vars)
      data = %( #{DataPagy.attr(:n, [pagy.vars[:page_sym], pagy.update])}) if pagy.keynav?
      %(<nav#{id && %( id="#{id}")} class="#{nav_classes}" #{NavAriaLabel.attr(frontend, pagy, aria_label:)}#{data}>#{html}</nav>)
    end
  end
end
