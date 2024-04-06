# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/semantic
# frozen_string_literal: true

require_relative 'js_tools'

class Pagy # :nodoc:
  # Frontend modules are specially optimized for performance.
  # The resulting code may not look very elegant, but produces the best benchmarks
  module SemanticExtra
    # Pagination for semantic: it returns the html with the series of links to the pages
    def pagy_semantic_nav(pagy, id: nil, aria_label: nil, **vars)
      id = %( id="#{id}") if id
      a  = pagy_anchor(pagy)

      html = %(<div#{id} role="navigation" class="pagy-semantic nav ui pagination menu" #{
                 nav_aria_label(pagy, aria_label:)}>#{semantic_prev_html(pagy, a)})
      pagy.series(**vars).each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << case item
                when Integer
                  a.(item, pagy.label_for(item), classes: 'item')
                when String
                  %(<a role="link" class="item active" aria-current="page" aria-disabled="true">#{pagy.label_for(item)}</a>)
                when :gap
                  %(<div class="disabled item">#{pagy_t 'pagy.gap'}</div>)
                else
                  raise InternalError, "expected item types in series to be Integer, String or :gap; got #{item.inspect}"
                end
      end
      html << %(#{semantic_next_html(pagy, a)}</div>)
    end

    # Javascript pagination for semantic: it returns a nav with a data-pagy attribute used by the pagy.js file
    def pagy_semantic_nav_js(pagy, id: nil, aria_label: nil, **vars)
      sequels = pagy.sequels(**vars)
      id      = %( id="#{id}") if id
      a       = pagy_anchor(pagy)
      tokens  = { 'before'  => semantic_prev_html(pagy, a),
                  'a'       => a.(PAGE_TOKEN, LABEL_TOKEN, classes: 'item'),
                  'current' => %(<a role="link" class="item active" aria-current="page" aria-disabled="true">#{LABEL_TOKEN}</a>),
                  'gap'     => %(<div class="disabled item">#{pagy_t('pagy.gap')}</div>),
                  'after'   => semantic_next_html(pagy, a) }

      %(<div#{id} class="#{'pagy-rjs ' if sequels.size > 1}pagy-semantic nav-js ui pagination menu" role="navigation" #{
          nav_aria_label(pagy, aria_label:)} #{
          pagy_data(pagy, :nav, tokens, sequels, pagy.label_sequels(sequels))
        }></div>)
    end

    # Combo pagination for semantic: it returns a nav with a data-pagy attribute used by the pagy.js file
    def pagy_semantic_combo_nav_js(pagy, id: nil, aria_label: nil)
      id    = %( id="#{id}") if id
      a     = pagy_anchor(pagy)
      pages = pagy.pages

      page_input = %(<input name="page" type="number" min="1" max="#{pages}" value="#{pagy.page}" aria-current="page") <<
                   %(style="text-align: center; width: #{pages.to_s.length + 1}rem; padding: 0; margin: 0 0.3rem">) <<
                   JSTools::A_TAG

      %(<div#{id} class="pagy-semantic combo-nav-js ui compact menu" role="navigation" #{
          nav_aria_label(pagy, aria_label:)} #{
          pagy_data(pagy, :combo, pagy_url_for(pagy, PAGE_TOKEN))
        }>#{
          semantic_prev_html(pagy, a)
        }<div class="item"><label>#{
          pagy_t('pagy.combo_nav_js', page_input:, pages:)
        }</label></div> #{
          semantic_next_html(pagy, a)
        }</div>)
    end

    private

    def semantic_prev_html(pagy, a)
      if (p_prev = pagy.prev)
        a.(p_prev, pagy_t('pagy.prev'), classes: 'item', aria_label: pagy_t('pagy.aria_label.prev'))
      else
        %(<div class="item disabled" role="a" aria-disabled="true" aria-label="#{
            pagy_t('pagy.aria_label.prev')}">#{pagy_t('pagy.prev')}</div>)
      end
    end

    def semantic_next_html(pagy, a)
      if (p_next = pagy.next)
        a.(p_next, pagy_t('pagy.next'), classes: 'item', aria_label: pagy_t('pagy.aria_label.next'))
      else
        %(<div class="item disabled" role="link" aria-disabled="true" aria=label="#{
            pagy_t('pagy.aria_label.prev')}">#{pagy_t('pagy.next')}</div>)
      end
    end
  end
  Frontend.prepend SemanticExtra
end
