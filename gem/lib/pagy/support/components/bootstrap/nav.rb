# frozen_string_literal: true

require_relative '../utils/nav_tag'
require_relative 'previous_next'

class Pagy
  class_eval do
    # Pagination for bootstrap: it returns the html with the series of links to the pages
    def bootstrap_nav(classes: 'pagination', **)
      anchor_lambda = anchor_lambda(**)
      html = %(<ul class="#{classes}">#{bootstrap_html_for(:previous, anchor_lambda)})
      series(**).each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << case item
                when Integer
                  %(<li class="page-item">#{anchor_lambda.(item, classes: 'page-link')}</li>)
                when String
                  %(<li class="page-item active"><a role="link" class="page-link" aria-current="page" aria-disabled="true">#{
                      label(page: item)}</a></li>)
                when :gap
                  %(<li class="page-item gap disabled"><a role="link" class="page-link" aria-disabled="true">#{
                  I18n.translate('pagy.gap')}</a></li>)
                else raise InternalError, "expected item types in series to be Integer, String or :gap; got #{item.inspect}"
                end
      end
      html << %(#{bootstrap_html_for(:next, anchor_lambda)}</ul>)
      nav_tag(html, 'pagy-bootstrap nav', **)
    end
  end
end
