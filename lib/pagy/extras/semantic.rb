# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/semantic
# encoding: utf-8
# frozen_string_literal: true

require 'pagy/extras/shared'

class Pagy
  module Frontend

    # Pagination for semantic: it returns the html with the series of links to the pages
    def pagy_semantic_nav(pagy)
      link, p_prev, p_next = pagy_link_proc(pagy, 'class="item"'), pagy.prev, pagy.next

      html = EMPTY + (p_prev ? %(#{link.call p_prev, '<i class="left small chevron icon"></i>', 'aria-label="previous"'})
                             : %(<div class="item disabled"><i class="left small chevron icon"></i></div>))
      pagy.series.each do |item|  # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << if    item.is_a?(Integer); %(#{link.call item})                      # page link
                elsif item.is_a?(String) ; %(<a class="item active">#{item}</a>)     # current page
                elsif item == :gap       ; %(<div class="disabled item">...</div>)   # page gap
                end
      end
      html << (p_next ? %(#{link.call p_next, '<i class="right small chevron icon"></i>', 'aria-label="next"'})
                      : %(<div class="item disabled"><i class="right small chevron icon"></i></div>))
      %(<div class="pagy-semantic-nav ui pagination menu" aria-label="pager">#{html}</div>)
    end

    # Javascript pagination for semantic: it returns a nav and a JSON tag used by the Pagy.nav javascript
    def pagy_semantic_nav_js(pagy, id=pagy_id)
      link, p_prev, p_next = pagy_link_proc(pagy, 'class="item"'), pagy.prev, pagy.next
      tags = { 'before' => (p_prev ? %(#{link.call(p_prev, '<i class="left small chevron icon"></i>', 'aria-label="previous"')})
                                   : %(<div class="item disabled"><i class="left small chevron icon"></i></div>)),
               'link'   => %(#{link.call(MARK)}),
               'active' => %(<a class="item active">#{pagy.page}</a>),
               'gap'    => %(<div class="disabled item">#{pagy_t('pagy.nav.gap')}</div>),
               'after'  => (p_next ? %(#{link.call(p_next, '<i class="right small chevron icon"></i>', 'aria-label="next"')})
                                   : %(<div class="item disabled"><i class="right small chevron icon"></i></div>)) }
      %(<div id="#{id}" class="pagy-semantic-nav-js ui pagination menu" role="navigation" aria-label="pager"></div>#{pagy_json_tag(:nav, id, tags, pagy.sequels, defined?(TRIM) && pagy.vars[:page_param])})
    end

    # Combo pagination for semantic: it returns a nav and a JSON tag used by the Pagy.combo_nav javascript
    def pagy_semantic_combo_nav_js(pagy, id=pagy_id)
      link, p_prev, p_next, p_page, p_pages = pagy_link_proc(pagy, 'class="item"'), pagy.prev, pagy.next, pagy.page, pagy.pages

      html = EMPTY + %(<div id="#{id}" class="pagy-semantic-combo-nav-js ui compact menu" role="navigation" aria-label="pager">)
      html << (p_prev ? %(#{link.call p_prev, '<i class="left small chevron icon"></i>', 'aria-label="previous"'})
                      : %(<div class="item disabled"><i class="left small chevron icon"></i></div>))
      input = %(<input type="number" min="1" max="#{p_pages}" value="#{p_page}" style="padding: 0; text-align: center; width: #{p_pages.to_s.length+1}rem; margin: 0 0.3rem">)
      html << %(<div class="pagy-combo-input item">#{pagy_t('pagy.combo_nav_js', page_input: input, count: p_page, pages: p_pages)}</div> )
      html << (p_next ? %(#{link.call p_next, '<i class="right small chevron icon"></i>', 'aria-label="next"'})
                      : %(<div class="item disabled"><i class="right small chevron icon"></i></div>))
      html << %(</div>#{pagy_json_tag(:combo_nav, id, p_page, pagy_marked_link(link), defined?(TRIM) && pagy.vars[:page_param])})
    end

  end
end
