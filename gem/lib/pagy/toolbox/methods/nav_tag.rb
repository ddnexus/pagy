# frozen_string_literal: true

require_relative 'support/nav'

class Pagy
  # Return the html with the series of links to the pages
  def nav_tag(style = nil, **)
    return send(:"#{style}_nav_tag", **) if style

    a_lambda = a_lambda(**)
    html     = previous_a_tag(a_lambda)
    series(**).each do |item|
      # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
      html << case item
              when Integer
                a_lambda.(item)
              when String
                %(<a role="link" aria-disabled="true" aria-current="page" class="current">#{page_label(item)}</a>)
              when :gap
                %(<a role="link" aria-disabled="true" class="gap">#{I18n.translate('pagy.gap')}</a>)
              else
                raise InternalError, "expected item types in series to be Integer, String or :gap; got #{item.inspect}"
              end
    end
    html << next_a_tag(a_lambda)
    wrap_nav(html, 'pagy nav', **)
  end
end
