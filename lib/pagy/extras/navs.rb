# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/navs
# frozen_string_literal: true

require 'pagy/extras/shared'

class Pagy
  module Frontend

    # Javascript pagination: it returns a nav and a JSON tag used by the Pagy.nav javascript
    def pagy_nav_js(pagy, id=pagy_id)
      link = pagy_link_proc(pagy)
      tags = { 'before' => pagy_nav_prev_html(pagy, link),
               'link'   => %(<span class="page">#{link.call(PAGE_PLACEHOLDER)}</span> ),
               'active' => %(<span class="page active">#{pagy.page}</span> ),
               'gap'    => %(<span class="page gap">#{pagy_t 'pagy.nav.gap'}</span> ),
               'after'  => pagy_nav_next_html(pagy, link) }

      html = %(<nav id="#{id}" class="pagy-nav-js pagination" role="navigation" aria-label="pager"></nav>)
      html << pagy_json_tag(pagy, :nav, id, tags, pagy.sequels)
    end

    # Javascript combo pagination: it returns a nav and a JSON tag used by the Pagy.combo_nav javascript
    def pagy_combo_nav_js(pagy, id=pagy_id)
      link    = pagy_link_proc(pagy)
      p_page  = pagy.page
      p_pages = pagy.pages
      input   = %(<input type="number" min="1" max="#{p_pages}" value="#{p_page}" style="padding: 0; text-align: center; width: #{p_pages.to_s.length+1}rem;">)

      %(<nav id="#{id}" class="pagy-combo-nav-js pagination" role="navigation" aria-label="pager">#{
          pagy_nav_prev_html pagy, link
      }<span class="pagy-combo-input" style="margin: 0 0.6rem;">#{
          pagy_t 'pagy.combo_nav_js', page_input: input, count: p_page, pages: p_pages
      }</span> #{
          pagy_nav_next_html pagy, link
      }</nav>#{
          pagy_json_tag pagy, :combo_nav, id, p_page, pagy_marked_link(link)
      })
    end

    private

      def pagy_nav_prev_html(pagy, link)
        if (p_prev = pagy.prev)
          %(<span class="page prev">#{link.call p_prev, pagy_t('pagy.nav.prev'), 'aria-label="previous"'}</span> )
        else
          %(<span class="page prev disabled">#{pagy_t 'pagy.nav.prev'}</span> )
        end
      end

      def pagy_nav_next_html(pagy, link)
        if (p_next = pagy.next)
          %(<span class="page next">#{link.call p_next, pagy_t('pagy.nav.next'), 'aria-label="next"'}</span>)
        else
          %(<span class="page next disabled">#{pagy_t 'pagy.nav.next'}</span>)
        end
      end

  end
end
