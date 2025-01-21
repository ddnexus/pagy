# frozen_string_literal: true

require_relative 'prev_next'

class Pagy
  Frontend.module_eval do
    # Pagination for bulma: it returns the html with the series of links to the pages
    def pagy_bulma_nav(pagy, classes: 'pagy-bulma nav pagination is-centered', **vars)
      a    = pagy_anchor(pagy, **vars)
      html = %(#{bulma_prev_next_html(pagy, a)}<ul class="pagination-list">)
      pagy.series(**vars).each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << case item
                when Integer
                  %(<li>#{a.(item, pagy.label_for(item), classes: 'pagination-link')}</li>)
                when String
                  %(<li><a role="link" class="pagination-link is-current" aria-current="page" aria-disabled="true">#{
                      pagy.label_for(item)}</a></li>)
                when :gap
                  %(<li><span class="pagination-ellipsis">#{pagy_t 'pagy.gap'}</span></li>)
                else raise InternalError, "expected item types in series to be Integer, String or :gap; got #{item.inspect}"
                end
      end
      html << %(</ul>)
      Front.build_nav(self, pagy, html, classes, **vars)
    end
  end
end
