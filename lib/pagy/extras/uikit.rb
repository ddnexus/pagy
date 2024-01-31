# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/uikit
# frozen_string_literal: true

require 'pagy/extras/frontend_helpers'

class Pagy # :nodoc:
  # Frontend modules are specially optimized for performance.
  # The resulting code may not look very elegant, but produces the best benchmarks
  module UikitExtra
    # Pagination for uikit: it returns the html with the series of links to the pages
    def pagy_uikit_nav(pagy, pagy_id: nil, link_extra: '',
                       nav_aria_label: nil, nav_i18n_key: nil, **vars)
      p_id = %( id="#{pagy_id}") if pagy_id
      link = pagy_link_proc(pagy, link_extra:)

      html = +%(<ul#{p_id} class="pagy-uikit-nav uk-pagination uk-flex-center" role="navigation"  #{

      nav_aria_label_attr(pagy, nav_aria_label, nav_i18n_key)}>#{uikit_prev_html(pagy, link)})
      pagy.series(**vars).each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << case item
                when Integer
                  %(<li>#{link.call(item)}</li>)
                when String
                  %(<li class="uk-active"><span role="link" aria-current="page" aria-disabled="true">#{
                      pagy.label_for(item)}</span></li>)
                when :gap
                  %(<li class="uk-disabled"><span>#{pagy_t 'pagy.gap'}</span></li>)
                else
                  raise InternalError, "expected item types in series to be Integer, String or :gap; got #{item.inspect}"
                end
      end
      html << uikit_next_html(pagy, link)
      html << %(</ul>)
    end

    # Javascript pagination for uikit: it returns a nav and a JSON tag used by the pagy.js file
    def pagy_uikit_nav_js(pagy, pagy_id: nil, link_extra: '',
                          nav_aria_label: nil, nav_i18n_key: nil, **vars)
      sequels = pagy.sequels(**vars)
      p_id = %( id="#{pagy_id}") if pagy_id
      link = pagy_link_proc(pagy, link_extra:)
      tags = { 'before' => uikit_prev_html(pagy, link),
               'link'   => %(<li>#{link.call(PAGE_PLACEHOLDER, LABEL_PLACEHOLDER)}</li>),
               'active' => %(<li class="uk-active"><span role="link" aria-current="page" aria-disabled="true">#{
                               LABEL_PLACEHOLDER}</span></li>),
               'gap'    => %(<li class="uk-disabled"><span>#{pagy_t 'pagy.gap'}</span></li>),
               'after'  => uikit_next_html(pagy, link) }

      %(<ul#{p_id} class="#{'pagy-rjs ' if sequels.size > 1}pagy-uikit-nav-js uk-pagination uk-flex-center" role="navigation" #{
          nav_aria_label_attr(pagy, nav_aria_label, nav_i18n_key)} #{
          pagy_data(pagy, :nav, tags, sequels, pagy.label_sequels(sequels))}></ul>)
    end

    # Javascript combo pagination for uikit: it returns a nav and a JSON tag used by the pagy.js file
    def pagy_uikit_combo_nav_js(pagy, pagy_id: nil, link_extra: '',
                                nav_aria_label: nil, nav_i18n_key: nil)
      p_id    = %( id="#{pagy_id}") if pagy_id
      link    = pagy_link_proc(pagy, link_extra:)
      p_page  = pagy.page
      p_pages = pagy.pages
      input   = %(<input type="number" min="1" max="#{p_pages}" value="#{
                    p_page}" style="text-align: center; width: #{p_pages.to_s.length + 1}rem;" aria-current="page">)

      %(<ul#{p_id} class="pagy-uikit-combo-nav-js uk-button-group uk-pagination uk-flex-center" role="navigation" #{
          nav_aria_label_attr(pagy, nav_aria_label, nav_i18n_key)} #{
          pagy_data(pagy, :combo, pagy_marked_link(link))
        }>#{
          uikit_prev_html pagy, link
        }<li>#{
          pagy_t 'pagy.combo_nav_js', page_input: input, count: p_page, pages: p_pages
        }</li>#{
          uikit_next_html pagy, link
        }</ul>)
    end

    private

    def uikit_prev_html(pagy, link)
      previous_span = %(<span uk-pagination-previous>#{pagy_t 'pagy.prev'}</span>)
      if (p_prev = pagy.prev)
        %(<li>#{link.call(p_prev, previous_span, prev_aria_label_attr)}</li>)
      else
        %(<li class="uk-disabled"><span role="link" aria-disabled="true" #{prev_aria_label_attr}>#{previous_span}</a></li>)
      end
    end

    def uikit_next_html(pagy, link)
      next_span = %(<span uk-pagination-next>#{pagy_t 'pagy.next'}</span>)
      if (p_next = pagy.next)
        %(<li>#{link.call(p_next, next_span, next_aria_label_attr)}</li>)
      else
        %(<li class="uk-disabled"><span role="link" aria-disabled="true" #{prev_aria_label_attr}>#{next_span}</span></li>)
      end
    end
  end
  Frontend.include UikitExtra
end
