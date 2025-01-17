# frozen_string_literal: true

require_relative 'modules/b64'
require_relative 'modules/i18n'
require_relative 'modules/url'
require_relative 'frontend/loader'

class Pagy
  # Frontend modules are specially optimized for performance.
  # The resulting code may not look very elegant, but produces the best benchmarks
  module Frontend
    include Url

    # Return a performance optimized lambda to generate the HTML anchor element (a tag)
    # Benchmarked on a 20 link nav: it is ~22x faster and uses ~18x less memory than rails' link_to
    def pagy_anchor(pagy, anchor_string: nil, **vars)
      anchor_string &&= %( #{anchor_string})
      left, right   = %(<a#{anchor_string} href="#{pagy_page_url(pagy, PAGE_TOKEN, **vars)}").split(PAGE_TOKEN, 2)
      # lambda used by all the helpers
      lambda do |page, text = pagy.label_for(page), classes: nil, aria_label: nil|
        classes    = %( class="#{classes}") if classes
        aria_label = %( aria-label="#{aria_label}") if aria_label
        %(#{left}#{page}#{right}#{classes}#{aria_label}>#{text}</a>)
      end
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
             count:          p_count, from: pagy.from, to: pagy.to
      }</span>)
    end

    # Similar to I18n.t: just ~18x faster using ~10x less memory
    # (@pagy_locale explicitly initialized in order to avoid warning)
    def pagy_t(key, **)
      Pagy::I18n.translate(@pagy_locale ||= nil, key, **)
    end

    # Return a data tag with the base64 encoded JSON-serialized args generated with the faster oj gem
    def pagy_data(_pagy, *args)
      data = defined?(::Oj) ? Oj.dump(args, mode: :compat) : JSON.dump(args)
      %(data-pagy="#{B64.encode(data)}")
    end

    def pagy_nav_aria_label(pagy, aria_label: nil)
      aria_label ||= pagy_t('pagy.aria_label.nav', count: pagy.pages)
      %(aria-label="#{aria_label}")
    end

    include Frontend::Loader
  end
end
