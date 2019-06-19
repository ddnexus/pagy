# encoding: utf-8
# frozen_string_literal: true

require 'pagy/extras/shared'

class Pagy
  module Frontend

    # Pagination for uikit: it returns the html with the series of links to the pages
    def pagy_uikit_nav(pagy)
      link, p_prev, p_next = pagy_link_proc(pagy), pagy.prev, pagy.next

      previous_span = "<span uk-pagination-previous>#{pagy_t('pagy.nav.prev')}</span>"
      html = EMPTY + (p_prev ? %(<li>#{link.call p_prev, previous_span}</li>)
                             : %(<li class="uk-disabled"><a href="#">#{previous_span}</a></li>))
      pagy.series.each do |item|
        html << if    item.is_a?(Integer); %(<li>#{link.call item}</li>)
                elsif item.is_a?(String) ; %(<li class="uk-active"><span>#{item}</span></li>)
                elsif item == :gap       ; %(<li class="uk-disabled"><span>#{pagy_t('pagy.nav.gap')}</span></li>)
                end
      end
      next_span = "<span uk-pagination-next>#{pagy_t('pagy.nav.next')}</span>"
      html << (p_next ? %(<li>#{link.call p_next, next_span}</li>)
                      : %(<li class="uk-disabled"><a href="#">#{next_span}</a></li>))
      %(<ul class="uk-pagination uk-flex-center">#{html}</ul>)
    end
  end
end
