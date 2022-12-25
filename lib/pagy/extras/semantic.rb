# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/semantic
# frozen_string_literal: true

require 'pagy/extras/frontend_helpers'

class Pagy # :nodoc:
  # Frontend modules are specially optimized for performance.
  # The resulting code may not look very elegant, but produces the best benchmarks
  module SemanticExtra
    # Pagination for semantic: it returns the html with the series of links to the pages
    def pagy_semantic_nav(pagy, pagy_id: nil, link_extra: '', **vars)
      p_id = %( id="#{pagy_id}") if pagy_id
      link = pagy_link_proc(pagy, link_extra: %(class="item" #{link_extra}))

      html = +%(<div#{p_id} class="pagy-semantic-nav ui pagination menu">)
      html << pagy_semantic_prev_html(pagy, link)
      pagy.series(**vars).each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << case item
                when Integer then link.call item
                when String  then %(<a class="item active">#{pagy.label_for(item)}</a>)
                when :gap    then %(<div class="disabled item">#{pagy_t 'pagy.nav.gap'}</div>)
                else raise InternalError, "expected item types in series to be Integer, String or :gap; got #{item.inspect}"
                end
      end
      html << pagy_semantic_next_html(pagy, link)
      html << %(</div>)
    end

    # Javascript pagination for semantic: it returns a nav and a JSON tag used by the pagy.js file
    def pagy_semantic_nav_js(pagy, pagy_id: nil, link_extra: '', **vars)
      sequels = pagy.sequels(**vars)
      p_id = %( id="#{pagy_id}") if pagy_id
      link = pagy_link_proc(pagy, link_extra: %(class="item" #{link_extra}))
      tags = { 'before' => pagy_semantic_prev_html(pagy, link),
               'link'   => link.call(PAGE_PLACEHOLDER, LABEL_PLACEHOLDER),
               'active' => %(<a class="item active">#{LABEL_PLACEHOLDER}</a>),
               'gap'    => %(<div class="disabled item">#{pagy_t('pagy.nav.gap')}</div>),
               'after'  => pagy_semantic_next_html(pagy, link) }

      %(<div#{p_id} class="#{'pagy-rjs ' if sequels.size > 1}pagy-semantic-nav-js ui pagination menu" role="navigation" #{
        pagy_data(pagy, :nav, tags, sequels, pagy.label_sequels(sequels))}></div>)
    end

    # Combo pagination for semantic: it returns a nav and a JSON tag used by the pagy.js file
    def pagy_semantic_combo_nav_js(pagy, pagy_id: nil, link_extra: '')
      p_id    = %( id="#{pagy_id}") if pagy_id
      link    = pagy_link_proc(pagy, link_extra: %(class="item" #{link_extra}))
      p_page  = pagy.page
      p_pages = pagy.pages
      input   = %(<input type="number" min="1" max="#{p_pages}" value="#{
                    p_page}" style="padding: 0; text-align: center; width: #{p_pages.to_s.length + 1}rem; margin: 0 0.3rem">)

      %(<div#{p_id} class="pagy-semantic-combo-nav-js ui compact menu" role="navigation" #{
          pagy_data(pagy, :combo, pagy_marked_link(link))}>#{
          pagy_semantic_prev_html pagy, link
        }<div class="pagy-combo-input item">#{
          pagy_t 'pagy.combo_nav_js', page_input: input, count: p_page, pages: p_pages
        }</div> #{
          pagy_semantic_next_html pagy, link
        }</div>)
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
  Frontend.prepend SemanticExtra
end
