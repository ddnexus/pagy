# frozen_string_literal: true

require_relative 'nav_aria_label_attribute'
require_relative 'data_pagy_attribute'

# Relegate internal functions. Make overriding navs easier.
class Pagy
  private

  # Build the nav tag, with the specific inner html for the style
  def nav_tag(html, nav_classes, id: nil, aria_label: nil, **)
    data = %( #{data_pagy_attribute(:n, @update)}) if keynav?
    %(<nav#{id && %( id="#{id}")} class="#{nav_classes}" #{nav_aria_label_attribute(aria_label:)}#{data}>#{html}</nav>)
  end
end
