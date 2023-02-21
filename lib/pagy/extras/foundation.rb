# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/foundation
# frozen_string_literal: true

require 'pagy/extras/frontend_helpers'

class Pagy # :nodoc:
  # Frontend modules are specially optimized for performance.
  # The resulting code may not look very elegant, but produces the best benchmarks
  module FoundationExtra
    # Pagination for Foundation: it returns the html with the series of links to the pages
    def pagy_foundation_nav(pagy, pagy_id: nil, link_extra: '', **vars)
      p_id = %( id="#{pagy_id}") if pagy_id
      link = pagy_link_proc(pagy, link_extra: link_extra)

      html = +%(<nav#{p_id} class="pagy-foundation-nav" aria-label="Pagination"><ul class="pagination">)
      html << pagy_foundation_prev_html(pagy, link)
      pagy.series(**vars).each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << case item
                when Integer then %(<li>#{link.call item}</li>)                        # page link
                when String  then %(<li class="current">#{pagy.label_for(item)}</li>)                  # active page
                when :gap    then %(<li class="ellipsis gap" aria-hidden="true"></li>) # page gap
                else raise InternalError, "expected item types in series to be Integer, String or :gap; got #{item.inspect}"
                end
      end
      html << pagy_foundation_next_html(pagy, link)
      html << %(</ul></nav>)
    end

    # Javascript pagination for foundation: it returns a nav and a JSON tag used by the pagy.js file
    def pagy_foundation_nav_js(pagy, pagy_id: nil, link_extra: '', **vars)
      sequels = pagy.sequels(**vars)
      p_id = %( id="#{pagy_id}") if pagy_id
      link = pagy_link_proc(pagy, link_extra: link_extra)
      tags = { 'before' => %(<ul class="pagination">#{pagy_foundation_prev_html pagy, link}),
               'link'   => %(<li>#{link.call(PAGE_PLACEHOLDER, LABEL_PLACEHOLDER)}</li>),
               'active' => %(<li class="current">#{LABEL_PLACEHOLDER}</li>),
               'gap'    => %(<li class="ellipsis gap" aria-hidden="true"></li>),
               'after'  => %(#{pagy_foundation_next_html pagy, link}</ul>) }

      %(<nav#{p_id} class="#{'pagy-rjs ' if sequels.size > 1}pagy-foundation-nav-js" aria-label="Pagination" #{
        pagy_data(pagy, :nav, tags, sequels, pagy.label_sequels(sequels))}></nav>)
    end

    # Javascript combo pagination for Foundation: it returns a nav and a JSON tag used by the pagy.js file
    def pagy_foundation_combo_nav_js(pagy, pagy_id: nil, link_extra: '')
      p_id    = %( id="#{pagy_id}") if pagy_id
      link    = pagy_link_proc(pagy, link_extra: link_extra)
      p_page  = pagy.page
      p_pages = pagy.pages
      input   = %(<input class="input-group-field cell shrink" type="number" min="1" max="#{
                    p_pages}" value="#{p_page}" style="width: #{
                    p_pages.to_s.length + 1}rem; padding: 0 0.3rem; margin: 0 0.3rem;">)

      %(<nav#{p_id} class="pagy-foundation-combo-nav-js" aria-label="Pagination"><div class="input-group" #{
          pagy_data(pagy, :combo, pagy_marked_link(link))}>#{
          if (p_prev  = pagy.prev)
            link.call p_prev, pagy_t('pagy.nav.prev'),
                      'style="margin-bottom: 0" aria-label="previous" class="prev button primary"'
          else
            %(<a style="margin-bottom: 0" class="prev button primary disabled" href="#">#{pagy_t 'pagy.nav.prev'}</a>)
          end
        }#{
          pagy_t('pagy.combo_nav_js', page_input: input, count: p_page, pages: p_pages)
          .sub!('<label>', '<label class="input-group-label">')}#{ # add the class to the official dictionary string
          if (p_next  = pagy.next)
            link.call p_next, pagy_t('pagy.nav.next'), 'style="margin-bottom: 0" aria-label="next" class="next button primary"'
          else
            %(<a style="margin-bottom: 0" class="next button primary disabled" href="#">#{pagy_t 'pagy.nav.next'}</a>)
          end
        }</div></nav>)
    end

    private

    def pagy_foundation_prev_html(pagy, link)
      if (p_prev = pagy.prev)
        %(<li class="prev">#{link.call p_prev, pagy_t('pagy.nav.prev'), 'aria-label="previous"'}</li>)
      else
        %(<li class="prev disabled">#{pagy_t 'pagy.nav.prev'}</li>)
      end
    end

    def pagy_foundation_next_html(pagy, link)
      if (p_next = pagy.next)
        %(<li class="next">#{link.call p_next, pagy_t('pagy.nav.next'), 'aria-label="next"'}</li>)
      else
        %(<li class="next disabled">#{pagy_t 'pagy.nav.next'}</li>)
      end
    end
  end
  Frontend.prepend FoundationExtra
end
