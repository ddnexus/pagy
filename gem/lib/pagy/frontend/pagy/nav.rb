# frozen_string_literal: true

require_relative '../utils/nav'

class Pagy
  Frontend.module_eval do
    # Return the html with the series of links to the pages
    def pagy_nav(pagy, **)
      anchor_lambda = pagy_anchor_lambda(pagy, **)
      html = pagy_previous_anchor(pagy, anchor_lambda)
      pagy.series(**).each do |item|
        # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << case item
                when Integer
                  anchor_lambda.(item)
                when String
                  %(<a role="link" aria-disabled="true" aria-current="page" class="current">#{pagy.label(page: item)}</a>)
                when :gap
                  %(<a role="link" aria-disabled="true" class="gap">#{pagy_translate('pagy.gap')}</a>)
                else
                  raise InternalError, "expected item types in series to be Integer, String or :gap; got #{item.inspect}"
                end
      end
      html << pagy_next_anchor(pagy, anchor_lambda)
      Nav.tag(self, pagy, html, 'pagy nav', **)
    end
  end
end
