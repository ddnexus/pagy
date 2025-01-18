# frozen_string_literal: true

require_relative 'prev_next'

class Pagy
  Frontend.module_eval do
    # Pagination for bulma: it returns the html with the series of links to the pages
    def pagy_bulma_nav(pagy, id: nil, classes: 'pagy-bulma nav pagination is-centered',
                       aria_label: nil, **vars)
      id   = %( id="#{id}") if id
      a    = pagy_anchor(pagy, **vars)
      data = %( #{pagy_data(pagy, :n)}) if /^Pagy::Keyset::Keynav/.match?(pagy.class.name)

      html = %(<nav#{id} class="#{classes}" #{pagy_nav_aria_label(pagy, aria_label:)}#{data}>)
      html << bulma_prev_next_html(pagy, a)
      html << %(<ul class="pagination-list">)
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
      html << %(</ul></nav>)
    end
  end
end
