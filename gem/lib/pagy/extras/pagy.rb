# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/pagy
# frozen_string_literal: true

require_relative 'js_tools'

class Pagy # :nodoc:
  # Frontend modules are specially optimized for performance.
  # The resulting code may not look very elegant, but produces the best benchmarks
  module PagyExtra
    # pagy_nav is defined in the Frontend itself
    # Javascript pagination: it returns a nav with a data-pagy attribute used by the pagy.js file
    def pagy_nav_js(pagy, id: nil, aria_label: nil, anchor_string: nil, **vars)
      sequels = pagy.sequels(**vars)
      id      = %( id="#{id}") if id
      a       = pagy_anchor(pagy, anchor_string:)
      tokens  = { 'before'  => prev_a(pagy, a),
                  'a'       => a.(PAGE_TOKEN, LABEL_TOKEN),
                  'current' => %(<a class="current" role="link" aria-current="page" aria-disabled="true">#{
                                   LABEL_TOKEN}</a>),
                  'gap'     => %(<a class="gap" role="link" aria-disabled="true">#{pagy_t('pagy.gap')}</a>),
                  'after'   => next_a(pagy, a) }

      %(<nav#{id} class="#{'pagy-rjs ' if sequels.size > 1}pagy nav-js" #{
          nav_aria_label(pagy, aria_label:)} #{
          pagy_data(pagy, :nav, tokens, sequels, pagy.label_sequels(sequels))
        }></nav>)
    end

    # Javascript combo pagination: it returns a nav with a data-pagy attribute used by the pagy.js file
    def pagy_combo_nav_js(pagy, id: nil, aria_label: nil, anchor_string: nil)
      id    = %( id="#{id}") if id
      a     = pagy_anchor(pagy, anchor_string:)
      pages = pagy.pages

      page_input = %(<input name="page" type="number" min="1" max="#{pages}" value="#{pagy.page}" aria-current="page" ) <<
                   %(style="text-align: center; width: #{pages.to_s.length + 1}rem; padding: 0;">#{JSTools::A_TAG})

      %(<nav#{id} class="pagy combo-nav-js" #{
          nav_aria_label(pagy, aria_label:)} #{
          pagy_data(pagy, :combo, pagy_url_for(pagy, PAGE_TOKEN))}>#{
          prev_a(pagy, a)
        }<label>#{
          pagy_t('pagy.combo_nav_js', page_input:, pages:)
        }</label>#{
          next_a(pagy, a)
        }</nav>)
    end

    # Return the previous page URL string or nil
    def pagy_prev_url(pagy, absolute: false)
      pagy_url_for(pagy, pagy.prev, absolute:) if pagy.prev
    end

    # Return the next page URL string or nil
    def pagy_next_url(pagy, absolute: false)
      pagy_url_for(pagy, pagy.next, absolute:) if pagy.next
    end

    # Return the enabled/disabled previous page anchor tag
    def pagy_prev_a(pagy, text: pagy_t('pagy.prev'), aria_label: pagy_t('pagy.aria_label.prev'), anchor_string: nil)
      a = pagy_anchor(pagy, anchor_string:)
      prev_a(pagy, a, text:, aria_label:)
    end

    # Return the enabled/disabled next page anchor tag
    def pagy_next_a(pagy, text: pagy_t('pagy.next'), aria_label: pagy_t('pagy.aria_label.next'), anchor_string: nil)
      a = pagy_anchor(pagy, anchor_string:)
      next_a(pagy, a, text:, aria_label:)
    end

    # Conditionally return the previous page link tag
    def pagy_prev_link(pagy, absolute: false)
      %(<link href="#{pagy_url_for(pagy, pagy.prev, absolute:)}"/>) if pagy.prev
    end

    # Conditionally return the next page link tag
    def pagy_next_link(pagy, absolute: false)
      %(<link href="#{pagy_url_for(pagy, pagy.next, absolute:)}"/>) if pagy.next
    end
  end
  Frontend.prepend PagyExtra
end
