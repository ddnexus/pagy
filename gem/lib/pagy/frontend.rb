# See Pagy::Frontend API documentation: https://ddnexus.github.io/pagy/docs/api/frontend
# frozen_string_literal: true

require_relative 'url_helpers'
require_relative 'i18n'

class Pagy
  # Used for search and replace, hardcoded also in the pagy.js file
  PAGE_TOKEN  = '__pagy_page__'
  LABEL_TOKEN = '__pagy_label__'

  # Frontend modules are specially optimized for performance.
  # The resulting code may not look very elegant, but produces the best benchmarks
  module Frontend
    include UrlHelpers

    # Generic pagination: it returns the html with the series of links to the pages
    def pagy_nav(pagy, id: nil, aria_label: nil, anchor_string: nil, **vars)
      id = %( id="#{id}") if id
      a  = pagy_anchor(pagy, anchor_string:)

      html = %(<nav#{id} class="pagy nav" #{nav_aria_label(pagy, aria_label:)}>#{
                 prev_a(pagy, a)})
      pagy.series(**vars).each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
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

    # Return examples: "Displaying items 41-60 of 324 in total" or "Displaying Products 41-60 of 324 in total"
    def pagy_info(pagy, id: nil, item_name: nil)
      id      = %( id="#{id}") if id
      p_count = pagy.count
      key     = if p_count.zero?
                  'pagy.info.no_items'
                elsif pagy.pages == 1
                  'pagy.info.single_page'
                else
                  'pagy.info.multiple_pages'
                end

      %(<span#{id} class="pagy info">#{
          pagy_t key, item_name: item_name || pagy_t('pagy.item_name', count: p_count),
                      count: p_count, from: pagy.from, to: pagy.to
        }</span>)
    end

    # Return a performance optimized lambda to generate the HTML anchor element (a tag)
    # Benchmarked on a 20 link nav: it is ~22x faster and uses ~18x less memory than rails' link_to
    def pagy_anchor(pagy, anchor_string: nil)
      anchor_string &&= %( #{anchor_string})
      left, right = %(<a#{anchor_string} href="#{pagy_url_for(pagy, PAGE_TOKEN)}").split(PAGE_TOKEN, 2)
      # lambda used by all the helpers
      lambda do |page, text = pagy.label_for(page), classes: nil, aria_label: nil|
        classes    = %( class="#{classes}") if classes
        aria_label = %( aria-label="#{aria_label}") if aria_label
        %(#{left}#{page}#{right}#{classes}#{aria_label}>#{text}</a>)
      end
    end

    # Similar to I18n.t: just ~18x faster using ~10x less memory
    # (@pagy_locale explicitly initialized in order to avoid warning)
    def pagy_t(key, opts = {})
      Pagy::I18n.translate(@pagy_locale ||= nil, key, opts)
    end

    private

    def nav_aria_label(pagy, aria_label: nil)
      aria_label ||= pagy_t('pagy.aria_label.nav', count: pagy.pages)
      %(aria-label="#{aria_label}")
    end

    def prev_a(pagy, a, text: pagy_t('pagy.prev'), aria_label: pagy_t('pagy.aria_label.prev'))
      if (p_prev = pagy.prev)
        a.(p_prev, text, aria_label:)
      else
        %(<a role="link" aria-disabled="true" aria-label="#{aria_label}">#{text}</a>)
      end
    end

    def next_a(pagy, a, text: pagy_t('pagy.next'), aria_label: pagy_t('pagy.aria_label.next'))
      if (p_next = pagy.next)
        a.(p_next, text, aria_label:)
      else
        %(<a role="link" aria-disabled="true" aria-label="#{aria_label}">#{text}</a>)
      end
    end
  end
end
