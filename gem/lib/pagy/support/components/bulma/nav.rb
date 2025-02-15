# frozen_string_literal: true

require_relative 'previous_next'
require_relative '../utils/nav_tag'

class Pagy
  private

  # Pagination for bulma: it returns the html with the series of links to the pages
  def bulma_nav(classes: 'pagination is-centered', **)
    anchor_lambda = anchor_lambda(**)
    html = %(#{bulma_previous_next_html(anchor_lambda)}<ul class="pagination-list">)
    series(**).each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
      html << case item
              when Integer
                %(<li>#{anchor_lambda.(item, label(page: item), classes: 'pagination-link')}</li>)
              when String
                %(<li><a role="link" class="pagination-link is-current" aria-current="page" aria-disabled="true">#{
                    label(page: item)}</a></li>)
              when :gap
                %(<li><span class="pagination-ellipsis">#{I18n.translate('pagy.gap')}</span></li>)
              else raise InternalError, "expected item types in series to be Integer, String or :gap; got #{item.inspect}"
              end
    end
    html << %(</ul>)
    nav_tag(html, "pagy-bulma nav #{classes}", **)
  end
end
