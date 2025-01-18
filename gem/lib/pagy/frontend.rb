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
      left, right     = %(<a#{anchor_string} href="#{pagy_page_url(pagy, PAGE_TOKEN, **vars)}").split(PAGE_TOKEN, 2)
      # lambda used by all the helpers
      lambda do |page, text = pagy.label_for(page), classes: nil, aria_label: nil|
        classes    &&= %( class="#{classes}")
        aria_label &&= %( aria-label="#{aria_label}")
        %(#{left}#{page}#{right}#{classes}#{aria_label}>#{text}</a>)
      end
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
