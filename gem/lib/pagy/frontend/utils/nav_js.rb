# frozen_string_literal: true

require_relative 'nav_aria_label'
require_relative 'data_pagy'

class Pagy
  # Relegate internal functions. Make overriding navs easier.
  module NavJs
    module_function

    # Build the nav_js tag, with the specific tokens for the style
    def tag(frontend, pagy, tokens, nav_classes, id: nil, aria_label: nil, **vars)
      sequels = pagy.sequels(**vars)
      id    &&= %( id="#{id}")
      %(<nav#{id} class="#{'pagy-rjs ' if sequels[0].size > 1}#{nav_classes}" #{
      NavAriaLabel.attr(frontend, pagy, aria_label:)} #{
      data = [:nj, tokens.values, *sequels]
      data.push([pagy.vars[:page_sym], pagy.update]) if pagy.keynav?
      DataPagy.attr(*data)
      }></nav>)
    end
  end
end
