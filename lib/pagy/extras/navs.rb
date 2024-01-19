# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/navs
# frozen_string_literal: true

require 'pagy/extras/frontend_helpers'

class Pagy # :nodoc:
  # Frontend modules are specially optimized for performance.
  # The resulting code may not look very elegant, but produces the best benchmarks
  module NavsExtra
    # Javascript pagination: it returns a nav and a JSON tag used by the pagy.js file
    def pagy_nav_js(pagy, pagy_id: nil, link_extra: '',
                    page_label: nil, page_i18n_key: nil, **vars)
      sequels = pagy.sequels(**vars)
      p_id = %( id="#{pagy_id}") if pagy_id
      link = pagy_link_proc(pagy, link_extra:)
      tags = { 'before' => pagy_nav_prev_html(pagy, link),
               'link'   => %(<span class="page">#{link.call(PAGE_PLACEHOLDER, LABEL_PLACEHOLDER)}</span> ),
               'active' => %(<span class="page active">) +
                           %(<a role="link" aria-disabled="true" aria-current="page">#{LABEL_PLACEHOLDER}</a></span> ),
               'gap'    => %(<span class="page gap">#{pagy_t 'pagy.nav.gap'}</span> ),
               'after'  => pagy_nav_next_html(pagy, link) }

      %(<nav#{p_id} class="#{'pagy-rjs ' if sequels.size > 1}pagy-nav-js pagination" #{
          pagy_aria_label(pagy, page_label, page_i18n_key)} #{
          pagy_data(pagy, :nav, tags, sequels, pagy.label_sequels(sequels))
        }></nav>)
    end

    # Javascript combo pagination: it returns a nav and a JSON tag used by the pagy.js file
    def pagy_combo_nav_js(pagy, pagy_id: nil, link_extra: '',
                          page_label: nil, page_i18n_key: nil)
      p_id    = %( id="#{pagy_id}") if pagy_id
      link    = pagy_link_proc(pagy, link_extra:)
      p_page  = pagy.page
      p_pages = pagy.pages
      input   = %(<input type="number" min="1" max="#{p_pages}" value="#{p_page}" ) +
                %(style="padding: 0; text-align: center; width: #{p_pages.to_s.length + 1}rem;">)

      %(<nav#{p_id} class="pagy-combo-nav-js pagination" #{
          pagy_aria_label(pagy, page_label, page_i18n_key)} #{
          pagy_data(pagy, :combo, pagy_marked_link(link))}>#{pagy_nav_prev_html(pagy, link)
        }<span class="pagy-combo-input" style="margin: 0 0.6rem;">#{
          pagy_t('pagy.combo_nav_js', page_input: input, count: p_page, pages: p_pages)
        }</span> #{
          pagy_nav_next_html(pagy, link)
        }</nav>)
    end
  end
  Frontend.prepend NavsExtra
end
