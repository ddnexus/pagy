# frozen_string_literal: true

require_relative 'prev_next'

class Pagy
  Frontend.module_eval do
    # Pagination for bootstrap: it returns the html with the series of links to the pages
    def pagy_bootstrap_nav(pagy, classes: 'pagination', **vars)
      a    = pagy_anchor(pagy, **vars)
      html = %(<ul class="#{classes}">#{bootstrap_prev_html(pagy, a)})
      pagy.series(**vars).each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << case item
                when Integer
                  %(<li class="page-item">#{a.(item, classes: 'page-link')}</li>)
                when String
                  %(<li class="page-item active"><a role="link" class="page-link" aria-current="page" aria-disabled="true">#{
                      pagy.label(page: item)}</a></li>)
                when :gap
                  %(<li class="page-item gap disabled"><a role="link" class="page-link" aria-disabled="true">#{
                      pagy_t('pagy.gap')}</a></li>)
                else raise InternalError, "expected item types in series to be Integer, String or :gap; got #{item.inspect}"
                end
      end
      html << %(#{bootstrap_next_html(pagy, a)}</ul>)
      Front.build_nav(self, pagy, html, 'pagy-bootstrap nav', **vars)
    end
  end
end
