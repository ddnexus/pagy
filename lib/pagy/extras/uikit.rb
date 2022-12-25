# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/uikit
# frozen_string_literal: true

require 'pagy/extras/frontend_helpers'

class Pagy # :nodoc:
  # Frontend modules are specially optimized for performance.
  # The resulting code may not look very elegant, but produces the best benchmarks
  module UikitExtra
    # Pagination for uikit: it returns the html with the series of links to the pages
    def pagy_uikit_nav(pagy, pagy_id: nil, link_extra: '', **vars)
      p_id = %( id="#{pagy_id}") if pagy_id
      link = pagy_link_proc(pagy, link_extra: link_extra)

      html = +%(<ul#{p_id} class="pagy-uikit-nav uk-pagination uk-flex-center">#{pagy_uikit_prev_html pagy, link})
      pagy.series(**vars).each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << case item
                when Integer then %(<li>#{link.call item}</li>)
                when String  then %(<li class="uk-active"><span>#{pagy.label_for(item)}</span></li>)
                when :gap    then %(<li class="uk-disabled"><span>#{pagy_t 'pagy.nav.gap'}</span></li>)
                else raise InternalError, "expected item types in series to be Integer, String or :gap; got #{item.inspect}"
                end
      end
      html << pagy_uikit_next_html(pagy, link)
      html << %(</ul>)
    end

    # Javascript pagination for uikit: it returns a nav and a JSON tag used by the pagy.js file
    def pagy_uikit_nav_js(pagy, pagy_id: nil, link_extra: '', **vars)
      sequels = pagy.sequels(**vars)
      p_id = %( id="#{pagy_id}") if pagy_id
      link = pagy_link_proc(pagy, link_extra: link_extra)
      tags = { 'before' => pagy_uikit_prev_html(pagy, link),
               'link'   => %(<li>#{link.call(PAGE_PLACEHOLDER, LABEL_PLACEHOLDER)}</li>),
               'active' => %(<li class="uk-active"><span>#{LABEL_PLACEHOLDER}</span></li>),
               'gap'    => %(<li class="uk-disabled"><span>#{pagy_t 'pagy.nav.gap'}</span></li>),
               'after'  => pagy_uikit_next_html(pagy, link) }

      %(<ul#{p_id} class="#{'pagy-rjs ' if sequels.size > 1}pagy-uikit-nav-js uk-pagination uk-flex-center" #{
        pagy_data(pagy, :nav, tags, sequels, pagy.label_sequels(sequels))}></ul>)
    end

    # Javascript combo pagination for uikit: it returns a nav and a JSON tag used by the pagy.js file
    def pagy_uikit_combo_nav_js(pagy, pagy_id: nil, link_extra: '')
      p_id    = %( id="#{pagy_id}") if pagy_id
      link    = pagy_link_proc(pagy, link_extra: link_extra)
      p_page  = pagy.page
      p_pages = pagy.pages
      input   = %(<input type="number" min="1" max="#{p_pages}" value="#{
                    p_page}" style="text-align: center; width: #{p_pages.to_s.length + 1}rem;">)

      %(<ul#{p_id} class="pagy-uikit-combo-nav-js uk-button-group uk-pagination uk-flex-center" #{
          pagy_data(pagy, :combo, pagy_marked_link(link))
        }>#{
          pagy_uikit_prev_html pagy, link
        }<li>#{
          pagy_t 'pagy.combo_nav_js', page_input: input, count: p_page, pages: p_pages
        }</li>#{
          pagy_uikit_next_html pagy, link
        }</ul>)
    end

    private

    def pagy_uikit_prev_html(pagy, link)
      previous_span = %(<span uk-pagination-previous>#{pagy_t 'pagy.nav.prev'}</span>)
      if (p_prev = pagy.prev)
        %(<li>#{link.call p_prev, previous_span}</li>)
      else
        %(<li class="uk-disabled"><a href="#">#{previous_span}</a></li>)
      end
    end

    def pagy_uikit_next_html(pagy, link)
      next_span = %(<span uk-pagination-next>#{pagy_t 'pagy.nav.next'}</span>)
      if (p_next = pagy.next)
        %(<li>#{link.call p_next, next_span}</li>)
      else
        %(<li class="uk-disabled"><a href="#">#{next_span}</a></li>)
      end
    end
  end
  Frontend.include UikitExtra
end
