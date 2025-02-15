# frozen_string_literal: true

require_relative 'nav_aria_label_attribute'
require_relative 'data_pagy_attribute'

# Relegate internal functions. Make overriding navs easier.
class Pagy
  private

  # Build the nav_js tag, with the specific tokens for the style
  def nav_js_tag(tokens, nav_classes, id: nil, aria_label: nil, **)
    sequels = sequels(**)
    %(<nav#{id && %( id="#{id}")} class="#{'pagy-rjs ' if sequels[0].size > 1}#{nav_classes}" #{
      nav_aria_label_attribute(aria_label:)} #{
      data = [:nj, tokens.values, sequels]
      data.push(@update) if keynav?
      data_pagy_attribute(*data)
    }></nav>)
  end
end
