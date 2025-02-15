# frozen_string_literal: true

require_relative '../utils/nav_tag'

class Pagy
  # Return the html with the series of links to the pages
  def nav(style: nil, **)
    if style
      require_relative "../#{style}/nav"
      return send(:"#{style}_nav", **)
    end

    anchor_lambda = anchor_lambda(**)
    html = previous_anchor(anchor_lambda)
    series(**).each do |item|
      # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
      html << case item
              when Integer
                anchor_lambda.(item)
              when String
                %(<a role="link" aria-disabled="true" aria-current="page" class="current">#{label(page: item)}</a>)
              when :gap
                %(<a role="link" aria-disabled="true" class="gap">#{I18n.translate('pagy.gap')}</a>)
              else
                raise InternalError, "expected item types in series to be Integer, String or :gap; got #{item.inspect}"
              end
    end
    html << next_anchor(anchor_lambda)
    nav_tag(html, 'pagy nav', **)
  end
end
