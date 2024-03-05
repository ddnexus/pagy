# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/semantic
# frozen_string_literal: true

require 'pagy/extras/frontend_helpers'

class Pagy # :nodoc:
  # Frontend modules are specially optimized for performance.
  # The resulting code may not look very elegant, but produces the best benchmarks
  module SemanticExtra
    # Pagination for semantic: it returns the html with the series of links to the pages
    def pagy_semantic_nav(pagy, pagy_id: nil, link_extra: '',
                          nav_aria_label: nil, nav_i18n_key: nil, **vars)
      p_id = %( id="#{pagy_id}") if pagy_id
      link = pagy_link_proc(pagy, link_extra:)

      html = +%(<div#{p_id} role="navigation" class="pagy-semantic-nav ui pagination menu" #{
                  nav_aria_label_attr(pagy, nav_aria_label, nav_i18n_key)}>)
      html << semantic_prev_html(pagy, link)
      pagy.series(**vars).each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << case item
                when Integer
                  link.call(item, pagy.label_for(item), %(class="item"))
                when String
                  %(<a role="link" class="item active" aria-current="page" aria-disabled="true">#{pagy.label_for(item)}</a>)
                when :gap
                  %(<div class="disabled item">#{pagy_t 'pagy.gap'}</div>)
                else
                  raise InternalError, "expected item types in series to be Integer, String or :gap; got #{item.inspect}"
                end
      end
      html << semantic_next_html(pagy, link)
      html << %(</div>)
    end

    # Javascript pagination for semantic: it returns a nav and a JSON tag used by the pagy.js file
    def pagy_semantic_nav_js(pagy, pagy_id: nil, link_extra: '',
                             nav_aria_label: nil, nav_i18n_key: nil, **vars)
      sequels = pagy.sequels(**vars)
      p_id = %( id="#{pagy_id}") if pagy_id
      link = pagy_link_proc(pagy, link_extra:)
      tags = { 'before' => semantic_prev_html(pagy, link),
               'link'   => link.call(PAGE_TOKEN, LABEL_TOKEN, %(class="item")),
               'active' => %(<a role="link" class="item active" aria-current="page" aria-disabled="true">#{LABEL_TOKEN}</a>),
               'gap'    => %(<div class="disabled item">#{pagy_t('pagy.gap')}</div>),
               'after'  => semantic_next_html(pagy, link) }

      %(<div#{p_id} class="#{'pagy-rjs ' if sequels.size > 1}pagy-semantic-nav-js ui pagination menu" role="navigation" #{
          nav_aria_label_attr(pagy, nav_aria_label, nav_i18n_key)} #{
          pagy_data(pagy, :nav, tags, sequels, pagy.label_sequels(sequels))}></div>)
    end

    # Combo pagination for semantic: it returns a nav and a JSON tag used by the pagy.js file
    def pagy_semantic_combo_nav_js(pagy, pagy_id: nil, link_extra: '',
                                   nav_aria_label: nil, nav_i18n_key: nil)
      p_id    = %( id="#{pagy_id}") if pagy_id
      link    = pagy_link_proc(pagy, link_extra: %(class="item" #{link_extra}))
      p_page  = pagy.page
      p_pages = pagy.pages
      input   = %(<input name="page" type="number" min="1" max="#{p_pages}" value="#{
                    p_page}" style="padding: 0; text-align: center; width: #{
                    p_pages.to_s.length + 1}rem; margin: 0 0.3rem" aria-current="page">)

      %(<div#{p_id} class="pagy-semantic-combo-nav-js ui compact menu" role="navigation" #{
          nav_aria_label_attr(pagy, nav_aria_label, nav_i18n_key)} #{
          pagy_data(pagy, :combo, pagy_url_for(pagy, PAGE_TOKEN))}>#{
          semantic_prev_html pagy, link
        }<div class="pagy-combo-input item">#{
          pagy_t 'pagy.combo_nav_js', page_input: input, count: p_page, pages: p_pages
        }</div> #{
          semantic_next_html pagy, link
        }</div>)
    end

    private

    def semantic_prev_html(pagy, link)
      if (p_prev = pagy.prev)
        link.call(p_prev, pagy_t('pagy.prev'), %(#{prev_aria_label_attr} class="item"))
      else
        +%(<div class="item disabled" role="link" aria-disabled="true" #{
             prev_aria_label_attr}>#{pagy_t('pagy.prev')}</div>)
      end
    end

    def semantic_next_html(pagy, link)
      if (p_next = pagy.next)
        link.call(p_next, pagy_t('pagy.next'), %(#{next_aria_label_attr} class="item"))
      else
        +%(<div class="item disabled" role="link" aria-disabled="true" #{
             next_aria_label_attr}>#{pagy_t('pagy.next')}</div>)
      end
    end
  end
  Frontend.prepend SemanticExtra
end
