# frozen_string_literal: true

class Pagy
  # Frontend modules are specially optimized for performance.
  # The resulting code may not look very elegant, but produces the best benchmarks
  Frontend.class_eval do
    # Generic pagination: it returns the html with the series of links to the pages
    def pagy_nav(pagy, id: nil, aria_label: nil, **vars)
      id   = %( id="#{id}") if id
      a    = pagy_anchor(pagy, **vars)
      data = %( #{pagy_data(pagy, :n)}) if defined?(::Pagy::Keyset::Keynav) && pagy.is_a?(Keyset::Keynav)

      html = %(<nav#{id} class="pagy nav" #{nav_aria_label(pagy, aria_label:)}#{data}>#{prev_a(pagy, a)})
      pagy.series(**vars).each do |item|
        # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << case item
                when Integer
                  a.(item)
                when String
                  %(<a role="link" aria-disabled="true" aria-current="page" class="current">#{pagy.label_for(item)}</a>)
                when :gap
                  %(<a role="link" aria-disabled="true" class="gap">#{pagy_t('pagy.gap')}</a>)
                else
                  raise InternalError, "expected item types in series to be Integer, String or :gap; got #{item.inspect}"
                end
      end
      html << %(#{next_a(pagy, a)}</nav>)
    end

    # Javascript pagination: it returns a nav with a data-pagy attribute used by the pagy.js file
    def pagy_nav_js(pagy, id: nil, aria_label: nil, **vars)
      sequels = pagy.sequels(**vars)
      id      = %( id="#{id}") if id
      a       = pagy_anchor(pagy, **vars)
      tokens  = { before:  prev_a(pagy, a),
                  anchor:  a.(PAGE_TOKEN, LABEL_TOKEN),
                  current: %(<a class="current" role="link" aria-current="page" aria-disabled="true">#{LABEL_TOKEN}</a>),
                  gap:     %(<a class="gap" role="link" aria-disabled="true">#{pagy_t('pagy.gap')}</a>),
                  after:   next_a(pagy, a) }
      %(<nav#{id} class="#{'pagy-rjs ' if sequels[0].size > 1}pagy nav-js" #{
          nav_aria_label(pagy, aria_label:)} #{
          pagy_data(pagy, :nj, tokens.values, *sequels)
        }></nav>)
    end

    # Javascript combo pagination: it returns a nav with a data-pagy attribute used by the pagy.js file
    def pagy_combo_nav_js(pagy, id: nil, aria_label: nil, **vars)
      id    = %( id="#{id}") if id
      a     = pagy_anchor(pagy, **vars)
      pages = pagy.pages

      page_input = %(<input name="page" type="number" min="1" max="#{pages}" value="#{pagy.page}" aria-current="page" ) <<
                   %(style="text-align: center; width: #{pages.to_s.length + 1}rem; padding: 0;">#{A_TAG})

      %(<nav#{id} class="pagy combo-nav-js" #{
          nav_aria_label(pagy, aria_label:)} #{
          pagy_data(pagy, :cj, pagy_page_url(pagy, PAGE_TOKEN, **vars))}>#{
          prev_a(pagy, a)
        }<label>#{
          pagy_t('pagy.combo_nav_js', page_input:, pages:)
        }</label>#{
          next_a(pagy, a)
        }</nav>)
    end
  end
end
