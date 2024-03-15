# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/navs
# frozen_string_literal: true

require 'pagy/extras/js_tools'

class Pagy # :nodoc:
  # Frontend modules are specially optimized for performance.
  # The resulting code may not look very elegant, but produces the best benchmarks
  module NavsExtra
    # Javascript pagination: it returns a nav with a data-pagy attribute used by the pagy.js file
    def pagy_nav_js(pagy, id: nil, aria_label: nil, **vars)
      sequels = pagy.sequels(**vars)
      id      = %( id="#{id}") if id
      a       = pagy_anchor(pagy)
      tokens  = { 'before'  => prev_html(pagy, a),
                  'a'       => a.(PAGE_TOKEN, LABEL_TOKEN),
                  'current' => %(<a class="current" role="link" aria-current="page" aria-disabled="true">#{
                                   LABEL_TOKEN}</a>),
                  'gap'     => %(<a class="gap" role="link" aria-disabled="true">#{pagy_t('pagy.gap')}</a>),
                  'after'   => next_html(pagy, a) }

      %(<nav#{id} class="#{'pagy-rjs ' if sequels.size > 1}pagy nav-js" #{
          nav_aria_label(pagy, aria_label:)} #{
          pagy_data(pagy, :nav, tokens, sequels, pagy.label_sequels(sequels))
        }></nav>)
    end

    # Javascript combo pagination: it returns a nav with a data-pagy attribute used by the pagy.js file
    def pagy_combo_nav_js(pagy, id: nil, aria_label: nil)
      id    = %( id="#{id}") if id
      a     = pagy_anchor(pagy)
      pages = pagy.pages

      page_input = %(<input name="page" type="number" min="1" max="#{pages}" value="#{pagy.page}" aria-current="page" ) <<
                   %(style="text-align: center; width: #{pages.to_s.length + 1}rem; padding: 0;">)

      %(<nav#{id} class="pagy combo-nav-js" #{
          nav_aria_label(pagy, aria_label:)} #{
          pagy_data(pagy, :combo, pagy_url_for(pagy, PAGE_TOKEN))}>#{
          prev_html(pagy, a)
        }<label>#{
          pagy_t('pagy.combo_nav_js', page_input:, pages:)
        }</label>#{
          next_html(pagy, a)
        }</nav>)
    end
  end
  Frontend.prepend NavsExtra
end
