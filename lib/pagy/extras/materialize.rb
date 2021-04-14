# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/materialize
# frozen_string_literal: true

require 'pagy/extras/shared'

class Pagy
  module Frontend

    # Pagination for materialize: it returns the html with the series of links to the pages
    def pagy_materialize_nav(pagy)
      link = pagy_link_proc(pagy)

      html = +%(<div class="pagy-materialize-nav pagination" role="navigation" aria-label="pager"><ul class="pagination">)
      html << pagy_materialize_prev_html(pagy, link)
      pagy.series.each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << case item
                when Integer then %(<li class="waves-effect">#{link.call item}</li>)                           # page link
                when String  then %(<li class="active">#{link.call item}</li>)                                 # active page
                when :gap    then %(<li class="gap disabled"><a href="#">#{pagy_t 'pagy.nav.gap'}</a></li>)    # page gap
                end
      end
      html << pagy_materialize_next_html(pagy, link)
      html << %(</ul></div>)
    end

    # Javascript pagination for materialize: it returns a nav and a JSON tag used by the Pagy.nav javascript
    def pagy_materialize_nav_js(pagy, id=pagy_id)
      link = pagy_link_proc(pagy)
      tags = { 'before' => %(<ul class="pagination">#{pagy_materialize_prev_html pagy, link}),
               'link'   => %(<li class="waves-effect">#{mark = link.call(PAGE_PLACEHOLDER)}</li>),
               'active' => %(<li class="active">#{mark}</li>),
               'gap'    => %(<li class="gap disabled"><a href="#">#{pagy_t 'pagy.nav.gap'}</a></li>),
               'after'  => %(#{pagy_materialize_next_html pagy, link}</ul>) }

      html = %(<div id="#{id}" class="pagy-materialize-nav-js" role="navigation" aria-label="pager"></div>)
      html << pagy_json_tag(pagy, :nav, id, tags, pagy.sequels)
    end

    # Javascript combo pagination for materialize: it returns a nav and a JSON tag used by the Pagy.combo_nav javascript
    def pagy_materialize_combo_nav_js(pagy, id=pagy_id)
      link    = pagy_link_proc(pagy)
      p_page  = pagy.page
      p_pages = pagy.pages
      style   = ' style="vertical-align: middle;"'
      input   = %(<input type="number" class="browser-default" min="1" max="#{p_pages}" value="#{p_page}" style="padding: 2px; border: none; border-radius: 2px; text-align: center; width: #{p_pages.to_s.length+1}rem;">)

      %(<div id="#{id}" class="pagy-materialize-combo-nav-js pagination" role="navigation" aria-label="pager"><div class="pagy-compact-chip role="group" style="height: 35px; border-radius: 18px; background: #e4e4e4; display: inline-block;"><ul class="pagination" style="margin: 0px;">#{
          pagy_materialize_prev_html pagy, link, style
      }<div class="pagy-combo-input btn-flat" style="cursor: default; padding: 0px">#{
          pagy_t 'pagy.combo_nav_js', page_input: input, count: p_page, pages: p_pages
      }</div>#{
          pagy_materialize_next_html pagy, link, style
      }</ul></div>#{
          pagy_json_tag pagy, :combo_nav, id, p_page, pagy_marked_link(link)
      })
    end

    private

      def pagy_materialize_prev_html(pagy, link, style='')
        if (p_prev = pagy.prev)
          %(<li class="waves-effect prev"#{style}>#{link.call p_prev, '<i class="material-icons">chevron_left</i>', 'aria-label="previous"'}</li>)
        else
          %(<li class="prev disabled"#{style}><a href="#"><i class="material-icons">chevron_left</i></a></li>)
        end
      end

      def pagy_materialize_next_html(pagy, link, style='')
        if (p_next = pagy.next)
          %(<li class="waves-effect next"#{style}>#{link.call p_next, '<i class="material-icons">chevron_right</i>', 'aria-label="next"'}</li>)
        else
          %(<li class="next disabled"#{style}><a href="#"><i class="material-icons">chevron_right</i></a></li>)
        end
      end

  end
end
