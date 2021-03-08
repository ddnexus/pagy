# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/uikit
# encoding: utf-8
# frozen_string_literal: true

require 'pagy/extras/shared'

class Pagy
  module Frontend

    # Pagination for uikit: it returns the html with the series of links to the pages
    def pagy_uikit_nav(pagy)
      link, p_prev, p_next = pagy_link_proc(pagy), pagy.prev, pagy.next

      previous_span = "<span uk-pagination-previous>#{pagy_t('pagy.nav.prev')}</span>"
      html = (p_prev ? %(<li>#{link.call p_prev, previous_span}</li>)
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
      %(<ul class="pagy-uikit-nav uk-pagination uk-flex-center">#{html}</ul>)
    end

    # Javascript pagination for uikit: it returns a nav and a JSON tag used by the Pagy.nav javascript
    def pagy_uikit_nav_js(pagy, id=pagy_id)
      link, p_prev, p_next = pagy_link_proc(pagy), pagy.prev, pagy.next
      previous_span = "<span uk-pagination-previous>#{pagy_t('pagy.nav.prev')}</span>"
      next_span     = "<span uk-pagination-next>#{pagy_t('pagy.nav.next')}</span>"
      tags = { 'before' => p_prev ? %(<li>#{link.call p_prev, previous_span}</li>)
                                  : %(<li class="uk-disabled"><a href="#">#{previous_span}</a></li>),
               'link'   => %(<li>#{link.call(PAGE_PLACEHOLDER)}</li>),
               'active' => %(<li class="uk-active"><span>#{PAGE_PLACEHOLDER}</span></li>),
               'gap'    => %(<li class="uk-disabled"><span>#{pagy_t('pagy.nav.gap')}</span></li>),
               'after'  => p_next ? %(<li>#{link.call p_next, next_span}</li>)
                                  : %(<li class="uk-disabled"><a href="#">#{next_span}</a></li>) }
      %(<ul id="#{id}" class="pagy-uikit-nav-js uk-pagination uk-flex-center"></ul>#{pagy_json_tag(:nav, id, tags, pagy.sequels, defined?(Trim) && pagy.vars[:page_param])})
    end

    # Javascript combo pagination for uikit: it returns a nav and a JSON tag used by the Pagy.combo_nav javascript
    def pagy_uikit_combo_nav_js(pagy, id=pagy_id)
      link, p_prev, p_next, p_page, p_pages = pagy_link_proc(pagy), pagy.prev, pagy.next, pagy.page, pagy.pages

      html = %(<div id="#{id}" class="pagy-uikit-combo-nav-js uk-button-group">)
      html = html + (p_prev ? link.call(p_prev, pagy_t('pagy.nav.prev'), 'class="uk-button uk-button-default"')
                            : %(<button class="uk-button uk-button-default" disabled>#{pagy_t('pagy.nav.prev')}</button>))

      html << %(<div class="uk-text-middle uk-margin-left uk-margin-right">)
      input = %(<input type="number" min="1" max="#{p_pages}" value="#{p_page}" class="uk-input" style="padding: 0; text-align: center; width: #{p_pages.to_s.length+1}rem;">)
      html << pagy_t('pagy.combo_nav_js', page_input: input, count: p_page, pages: p_pages) + '</div>'

      html << (p_next ? link.call(p_next, pagy_t('pagy.nav.next'), 'class="uk-button uk-button-default"')
                      : %(<button class="uk-button uk-button-default" disabled>#{pagy_t('pagy.nav.next')}</button>))

      html << %(</div>#{pagy_json_tag(:combo_nav, id, p_page, pagy_marked_link(link), defined?(Trim) && pagy.vars[:page_param])})
    end
  end
end
