# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/bootstrap
# frozen_string_literal: true

require 'pagy/extras/frontend_helpers'

class Pagy # :nodoc:
  # Frontend modules are specially optimized for performance.
  # The resulting code may not look very elegant, but produces the best benchmarks
  module BootstrapExtra
    # Pagination for bootstrap: it returns the html with the series of links to the pages
    def pagy_bootstrap_nav(pagy, pagy_id: nil, link_extra: '',
                           nav_aria_label: nil, nav_i18n_key: nil, **vars)
      p_id = %( id="#{pagy_id}") if pagy_id
      link = pagy_link_proc(pagy, link_extra: %(class="page-link" #{link_extra}))

      html = +%(<nav#{p_id} class="pagy-bootstrap-nav" #{
                  nav_aria_label_attr(pagy, nav_aria_label, nav_i18n_key)}><ul class="pagination">)
      html << bootstrap_prev_html(pagy, link)
      pagy.series(**vars).each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << case item
                when Integer
                  %(<li class="page-item">#{link.call(item)}</li>)
                when String
                  %(<li class="page-item active"><a class="page-link" href="#" aria-current="page">#{
                      pagy.label_for(item)}</a></li>)
                when :gap
                  %(<li class="page-item gap disabled"><a href="#" class="page-link" aria-disabled="true">#{
                      pagy_t 'pagy.gap'}</a></li>)
                else raise InternalError, "expected item types in series to be Integer, String or :gap; got #{item.inspect}"
                end
      end
      html << bootstrap_next_html(pagy, link)
      html << %(</ul></nav>)
    end

    # Javascript pagination for bootstrap: it returns a nav and a JSON tag used by the pagy.js file
    def pagy_bootstrap_nav_js(pagy, pagy_id: nil, link_extra: '',
                              nav_aria_label: nil, nav_i18n_key: nil, **vars)
      sequels = pagy.sequels(**vars)
      p_id = %( id="#{pagy_id}") if pagy_id
      link = pagy_link_proc(pagy, link_extra: %(class="page-link" #{link_extra}))
      tags = { 'before' => %(<ul class="pagination">#{bootstrap_prev_html pagy, link}),
               'link'   => %(<li class="page-item">#{link.call(PAGE_PLACEHOLDER, LABEL_PLACEHOLDER)}</li>),
               'active' => %(<li class="page-item active"><a class="page-link" href="#" aria-current="page">#{
                               LABEL_PLACEHOLDER}</a></li>),
               'gap'    => %(<li class="page-item gap disabled"><a href="#" class="page-link" aria-disabled="true">#{
                               pagy_t 'pagy.gap'}</a></li>),
               'after'  => %(#{bootstrap_next_html pagy, link}</ul>) }

      %(<nav#{p_id} class="#{'pagy-rjs ' if sequels.size > 1}pagy-bootstrap-nav-js" #{
          nav_aria_label_attr(pagy, nav_aria_label, nav_i18n_key)} #{
          pagy_data(pagy, :nav, tags, sequels, pagy.label_sequels(sequels))
        }></nav>)
    end

    # Javascript combo pagination for bootstrap: it returns a nav and a JSON tag used by the pagy.js file
    def pagy_bootstrap_combo_nav_js(pagy, pagy_id: nil, link_extra: '',
                                    nav_aria_label: nil, nav_i18n_key: nil)
      p_id    = %( id="#{pagy_id}") if pagy_id
      link    = pagy_link_proc(pagy, link_extra:)
      p_page  = pagy.page
      p_pages = pagy.pages
      input   = %(<input type="number" min="1" max="#{p_pages}" value="#{
                    p_page}" style="padding: 0; border: none; text-align: center; width: #{
                    p_pages.to_s.length + 1}rem;" aria-current="page">)

      %(<nav#{p_id} class="pagy-bootstrap-combo-nav-js pagination" #{
          nav_aria_label_attr(pagy, nav_aria_label, nav_i18n_key)}><div class="btn-group" role="group" #{
          pagy_data(pagy, :combo, pagy_marked_link(link))}>#{
          if (p_prev = pagy.prev)
            link.call(p_prev, pagy_t('pagy.prev'), %(class="prev btn btn-primary" #{prev_aria_label_attr}))
          else
            %(<a class="prev btn btn-primary disabled" href="#" aria-disabled="true" #{
                prev_aria_label_attr}>#{pagy_t('pagy.prev')}</a>)
          end
        }<div class="pagy-combo-input btn btn-secondary" style="white-space: nowrap;">#{
          pagy_t 'pagy.combo_nav_js', page_input: input, count: p_page, pages: p_pages}</div>#{
          if (p_next = pagy.next)
            link.call(p_next, pagy_t('pagy.next'), %(class="next btn btn-primary" #{next_aria_label_attr}))
          else
            %(<a class="next btn btn-primary disabled" href="#" aria-disabled="true" #{
                next_aria_label_attr}>#{pagy_t 'pagy.next'}</a>)
          end
        }</div></nav>)
    end

    private

    def bootstrap_prev_html(pagy, link)
      if (p_prev = pagy.prev)
        %(<li class="page-item prev">#{link.call(p_prev, pagy_t('pagy.prev'), prev_aria_label_attr)}</li>)
      else
        %(<li class="page-item prev disabled"><a href="#" class="page-link" aria-disabled="true" #{
            prev_aria_label_attr}>#{pagy_t('pagy.prev')}</a></li>)
      end
    end

    def bootstrap_next_html(pagy, link)
      if (p_next = pagy.next)
        %(<li class="page-item next">#{link.call p_next, pagy_t('pagy.next'), next_aria_label_attr}</li>)
      else
        %(<li class="page-item next disabled"><a href="#" class="page-link" aria-disabled="true" #{
            next_aria_label_attr}>#{pagy_t('pagy.next')}</a></li>)
      end
    end
  end
  Frontend.prepend BootstrapExtra
end
