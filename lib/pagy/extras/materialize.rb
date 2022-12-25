# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/materialize
# frozen_string_literal: true

require 'pagy/extras/frontend_helpers'

class Pagy # :nodoc:
  # Frontend modules are specially optimized for performance.
  # The resulting code may not look very elegant, but produces the best benchmarks
  module MaterializeExtra
    # Pagination for materialize: it returns the html with the series of links to the pages
    def pagy_materialize_nav(pagy, pagy_id: nil, link_extra: '', **vars)
      p_id = %( id="#{pagy_id}") if pagy_id
      link = pagy_link_proc(pagy, link_extra: link_extra)

      html = +%(<div#{p_id} class="pagy-materialize-nav pagination" role="navigation"><ul class="pagination">)
      html << pagy_materialize_prev_html(pagy, link)
      pagy.series(**vars).each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << case item
                when Integer then %(<li class="waves-effect">#{link.call item}</li>)                           # page link
                when String  then %(<li class="active">#{link.call item}</li>)                                 # active page
                when :gap    then %(<li class="gap disabled"><a href="#">#{pagy_t 'pagy.nav.gap'}</a></li>)    # page gap
                else raise InternalError, "expected item types in series to be Integer, String or :gap; got #{item.inspect}"
                end
      end
      html << pagy_materialize_next_html(pagy, link)
      html << %(</ul></div>)
    end

    # Javascript pagination for materialize: it returns a nav and a JSON tag used by the pagy.js file
    def pagy_materialize_nav_js(pagy, pagy_id: nil, link_extra: '', **vars)
      sequels = pagy.sequels(**vars)
      p_id = %( id="#{pagy_id}") if pagy_id
      link = pagy_link_proc(pagy, link_extra: link_extra)

      tags = { 'before' => %(<ul class="pagination">#{pagy_materialize_prev_html pagy, link}),
               'link'   => %(<li class="waves-effect">#{mark = link.call(PAGE_PLACEHOLDER, LABEL_PLACEHOLDER)}</li>),
               'active' => %(<li class="active">#{mark}</li>),
               'gap'    => %(<li class="gap disabled"><a href="#">#{pagy_t 'pagy.nav.gap'}</a></li>),
               'after'  => %(#{pagy_materialize_next_html pagy, link}</ul>) }

      %(<div#{p_id} class="#{'pagy-rjs ' if sequels.size > 1}pagy-materialize-nav-js" role="navigation" #{
        pagy_data(pagy, :nav, tags, sequels, pagy.label_sequels(sequels))}></div>)
    end

    # Javascript combo pagination for materialize: it returns a nav and a JSON tag used by the pagy.js file
    def pagy_materialize_combo_nav_js(pagy, pagy_id: nil, link_extra: '')
      p_id    = %( id="#{pagy_id}") if pagy_id
      link    = pagy_link_proc(pagy, link_extra: link_extra)
      p_page  = pagy.page
      p_pages = pagy.pages
      style   = ' style="vertical-align: middle"'
      input   = %(<input type="number" class="browser-default" min="1" max="#{p_pages}" value="#{
                    p_page}" style="text-align: center; width: #{p_pages.to_s.length + 1}rem;">)

      html = %(<ul#{p_id} class="pagy-materialize-combo-nav-js pagination chip" role="navigation")
      %(#{html} style="padding-right: 0" #{
          pagy_data(pagy, :combo, pagy_marked_link(link))}>#{
          pagy_materialize_prev_html pagy, link, style}<li class="pagy-combo-input">#{
          pagy_t 'pagy.combo_nav_js', page_input: input, count: p_page, pages: p_pages}</li>#{
          pagy_materialize_next_html pagy, link, style}</ul>)
    end

    private

    def pagy_materialize_prev_html(pagy, link, style = '')
      if (p_prev = pagy.prev)
        %(<li class="waves-effect prev"#{style}>#{
            link.call p_prev, '<i class="material-icons">chevron_left</i>', 'aria-label="previous"'}</li>)
      else
        %(<li class="prev disabled"#{style}><a href="#"><i class="material-icons">chevron_left</i></a></li>)
      end
    end

    def pagy_materialize_next_html(pagy, link, style = '')
      if (p_next = pagy.next)
        %(<li class="waves-effect next"#{style}>#{
            link.call p_next, '<i class="material-icons">chevron_right</i>', 'aria-label="next"'}</li>)
      else
        %(<li class="next disabled"#{style}><a href="#"><i class="material-icons">chevron_right</i></a></li>)
      end
    end
  end
  Frontend.prepend MaterializeExtra
end
