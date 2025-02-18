# frozen_string_literal: true

require_relative 'nav_aria_label_attribute'
require_relative 'data_pagy_attribute'

# Relegate internal functions. Make overriding navs easier.
class Pagy
  private

  # Build the combo_nav_js tag, with the specific inner html for the style
  def wrap_combo_nav_js(html, nav_classes, id: nil, aria_label: nil, **)
    %(<nav#{%( id="#{id}") if id} class="#{nav_classes}" #{
      nav_aria_label_attribute(aria_label:)} #{
      data = [:cj, page_url(PAGE_TOKEN, **)]
      data.push(@update) if keynav?
      data_pagy_attribute(*data)
      }>#{html}</nav>)
  end
end
