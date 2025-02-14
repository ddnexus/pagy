# frozen_string_literal: true

require_relative 'nav_aria_label_attribute'
require_relative 'data_pagy_attribute'

# Relegate internal functions. Make overriding navs easier.
class Pagy
  class_eval do
    # Build the combo_nav_js tag, with the specific inner html for the style
    def combo_nav_js_tag(html, nav_classes, id: nil, aria_label: nil, **)
      %(<nav#{%( id="#{id}") if id} class="#{nav_classes}" #{
        nav_aria_label_attribute(aria_label:)} #{
        data = [:cj, page_url(PAGE_TOKEN, **)]
        data.push(@update) if keynav?
        data_pagy_attribute(*data)
      }>#{html}</nav>)
    end
  end
end
