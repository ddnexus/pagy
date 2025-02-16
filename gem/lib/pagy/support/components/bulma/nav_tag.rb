# frozen_string_literal: true

require_relative 'previous_next_html'
require_relative '../utils/wrap_nav'

class Pagy
  private

  # Pagination for bulma: it returns the html with the series of links to the pages
  def bulma_nav_tag(classes: 'pagination is-centered', **)
    a_lambda = a_lambda(**)
    html     = %(#{bulma_previous_next_html(a_lambda)}<ul class="pagination-list">)
    series(**).each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
      html << case item
              when Integer
                %(<li>#{a_lambda.(item, page_label(item), classes: 'pagination-link')}</li>)
              when String
                %(<li><a role="link" class="pagination-link is-current" aria-current="page" aria-disabled="true">#{
                    page_label(item)}</a></li>)
              when :gap
                %(<li><span class="pagination-ellipsis">#{I18n.translate('pagy.gap')}</span></li>)
              else raise InternalError, "expected item types in series to be Integer, String or :gap; got #{item.inspect}"
              end
    end
    html << %(</ul>)
    wrap_nav(html, "pagy-bulma nav #{classes}", **)
  end
end
