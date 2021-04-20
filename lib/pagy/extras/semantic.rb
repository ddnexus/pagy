# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/semantic
# frozen_string_literal: true

require 'pagy/extras/shared'

class Pagy
  module Frontend

    # Pagination for semantic: it returns the html with the series of links to the pages
    def pagy_semantic_nav(pagy)
      link = pagy_link_proc(pagy, 'class="item"')

      html = +%(<div class="pagy-semantic-nav ui pagination menu" aria-label="pager">)
      html << pagy_semantic_prev_html(pagy, link)
      pagy.series.each do |item|  # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << case item
                when Integer then link.call item                            # page link
                when String  then %(<a class="item active">#{item}</a>)     # current page
                when :gap    then %(<div class="disabled item">...</div>)   # page gap
                end
      end
      html << pagy_semantic_next_html(pagy, link)
      html << %(</div>)
    end

    # Javascript pagination for semantic: it returns a nav and a JSON tag used by the Pagy.nav javascript
    def pagy_semantic_nav_js(pagy, id=pagy_id)
      link = pagy_link_proc(pagy, 'class="item"')
      tags = { 'before' => pagy_semantic_prev_html(pagy, link),
               'link'   => link.call(PAGE_PLACEHOLDER),
               'active' => %(<a class="item active">#{pagy.page}</a>),
               'gap'    => %(<div class="disabled item">#{pagy_t('pagy.nav.gap')}</div>),
               'after'  => pagy_semantic_next_html(pagy, link) }

      html = %(<div id="#{id}" class="pagy-semantic-nav-js ui pagination menu" role="navigation" aria-label="pager"></div>)
      html << pagy_json_tag(pagy, :nav, tags, pagy.sequels)
    end

    # Combo pagination for semantic: it returns a nav and a JSON tag used by the Pagy.combo_nav javascript
    def pagy_semantic_combo_nav_js(pagy, id=pagy_id)
      link    = pagy_link_proc(pagy, 'class="item"')
      p_page  = pagy.page
      p_pages = pagy.pages
      input   = %(<input type="number" min="1" max="#{p_pages}" value="#{p_page}" style="padding: 0; text-align: center; width: #{p_pages.to_s.length+1}rem; margin: 0 0.3rem">)

      %(<div id="#{id}" class="pagy-semantic-combo-nav-js ui compact menu" role="navigation" aria-label="pager">#{
         pagy_semantic_prev_html pagy, link
      }<div class="pagy-combo-input item">#{
         pagy_t 'pagy.combo_nav_js', page_input: input, count: p_page, pages: p_pages
      }</div> #{
         pagy_semantic_next_html pagy, link
      }</div>#{
         pagy_json_tag pagy, :combo_nav, p_page, pagy_marked_link(link)
      })
    end

    private

      def pagy_semantic_prev_html(pagy, link)
        if (p_prev = pagy.prev)
          link.call p_prev, '<i class="left small chevron icon"></i>', 'aria-label="previous"'
        else
          +%(<div class="item disabled"><i class="left small chevron icon"></i></div>)
        end
      end

      def pagy_semantic_next_html(pagy, link)
        if (p_next = pagy.next)
          link.call p_next, '<i class="right small chevron icon"></i>', 'aria-label="next"'
        else
          +%(<div class="item disabled"><i class="right small chevron icon"></i></div>)
        end
      end

  end
end
