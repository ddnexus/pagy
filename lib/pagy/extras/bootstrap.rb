# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/bootstrap
# frozen_string_literal: true

require 'pagy/extras/frontend_helpers'

class Pagy # :nodoc:
  # Frontend modules are specially optimized for performance.
  # The resulting code may not look very elegant, but produces the best benchmarks
  module BootstrapExtra
    # Pagination for bootstrap: it returns the html with the series of links to the pages
    def pagy_bootstrap_nav(pagy, pagy_id: nil, link_extra: '', **vars)
      p_id = %( id="#{pagy_id}") if pagy_id
      link = pagy_link_proc(pagy, link_extra: %(class="page-link" #{link_extra}))

      html = +%(<nav#{p_id} class="pagy-bootstrap-nav"><ul class="pagination">)
      html << pagy_bootstrap_prev_html(pagy, link)
      pagy.series(**vars).each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << case item
                when Integer
                  %(<li class="page-item">#{link.call item}</li>)
                when String
                  %(<li class="page-item active">#{link.call item}</li>)
                when :gap
                  %(<li class="page-item gap disabled"><a href="#" class="page-link">#{pagy_t 'pagy.nav.gap'}</a></li>)
                else raise InternalError, "expected item types in series to be Integer, String or :gap; got #{item.inspect}"
                end
      end
      html << pagy_bootstrap_next_html(pagy, link)
      html << %(</ul></nav>)
    end

    # Javascript pagination for bootstrap: it returns a nav and a JSON tag used by the pagy.js file
    def pagy_bootstrap_nav_js(pagy, pagy_id: nil, link_extra: '', **vars)
      sequels = pagy.sequels(**vars)
      p_id = %( id="#{pagy_id}") if pagy_id
      link = pagy_link_proc(pagy, link_extra: %(class="page-link" #{link_extra}))
      tags = { 'before' => %(<ul class="pagination">#{pagy_bootstrap_prev_html pagy, link}),
               'link'   => %(<li class="page-item">#{mark = link.call(PAGE_PLACEHOLDER, LABEL_PLACEHOLDER)}</li>),
               'active' => %(<li class="page-item active">#{mark}</li>),
               'gap'    => %(<li class="page-item gap disabled"><a href="#" class="page-link">#{pagy_t 'pagy.nav.gap'}</a></li>),
               'after'  => %(#{pagy_bootstrap_next_html pagy, link}</ul>) }

      %(<nav#{p_id} class="#{'pagy-rjs ' if sequels.size > 1}pagy-bootstrap-nav-js" #{
        pagy_data(pagy, :nav, tags, sequels, pagy.label_sequels(sequels))}></nav>)
    end

    # Javascript combo pagination for bootstrap: it returns a nav and a JSON tag used by the pagy.js file
    def pagy_bootstrap_combo_nav_js(pagy, pagy_id: nil, link_extra: '')
      p_id    = %( id="#{pagy_id}") if pagy_id
      link    = pagy_link_proc(pagy, link_extra: link_extra)
      p_page  = pagy.page
      p_pages = pagy.pages
      input   = %(<input type="number" min="1" max="#{p_pages}" value="#{
                    p_page}" style="padding: 0; border: none; text-align: center; width: #{
                    p_pages.to_s.length + 1}rem;">)

      %(<nav#{p_id} class="pagy-bootstrap-combo-nav-js pagination"><div class="btn-group" role="group" #{
          pagy_data(pagy, :combo, pagy_marked_link(link))}>#{
          if (p_prev = pagy.prev)
            link.call p_prev, pagy_t('pagy.nav.prev'), 'aria-label="previous" class="prev btn btn-primary"'
          else
            %(<a class="prev btn btn-primary disabled" href="#">#{pagy_t('pagy.nav.prev')}</a>)
          end
        }<div class="pagy-combo-input btn btn-secondary" style="white-space: nowrap;">#{
          pagy_t 'pagy.combo_nav_js', page_input: input, count: p_page, pages: p_pages}</div>#{
          if (p_next  = pagy.next)
            link.call p_next, pagy_t('pagy.nav.next'), 'aria-label="next" class="next btn btn-primary"'
          else
            %(<a class="next btn btn-primary disabled" href="#">#{pagy_t 'pagy.nav.next'}</a>)
          end
        }</div></nav>)
    end

    private

    def pagy_bootstrap_prev_html(pagy, link)
      if (p_prev = pagy.prev)
        %(<li class="page-item prev">#{link.call p_prev, pagy_t('pagy.nav.prev'), 'aria-label="previous"'}</li>)
      else
        %(<li class="page-item prev disabled"><a href="#" class="page-link">#{pagy_t 'pagy.nav.prev'}</a></li>)
      end
    end

    def pagy_bootstrap_next_html(pagy, link)
      if (p_next = pagy.next)
        %(<li class="page-item next">#{link.call p_next, pagy_t('pagy.nav.next'), 'aria-label="next"'}</li>)
      else
        %(<li class="page-item next disabled"><a href="#" class="page-link">#{pagy_t 'pagy.nav.next'}</a></li>)
      end
    end
  end
  Frontend.prepend BootstrapExtra
end
