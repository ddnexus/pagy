# frozen_string_literal: true

require_relative 'modules/url'
require_relative 'frontend/loader'

class Pagy
  # Module to include in the app helper
  module Frontend
    include Url

    # Return a performance optimized lambda to generate the HTML anchor element (a tag)
    # Benchmarked on a 20 link nav: it is ~22x faster and uses ~18x less memory than rails' link_to
    def pagy_anchor(pagy, anchor_string: nil, **vars)
      left, right = %(<a#{%( #{anchor_string}) if anchor_string} href="#{pagy_page_url(pagy, PAGE_TOKEN, **vars)}")
                    .split(PAGE_TOKEN, 2)
      # Lambda used by all the helpers
      lambda do |page, text = pagy.label(page: page), classes: nil, aria_label: nil|
        %(#{left}#{page}#{right}#{%( class="#{classes}") if classes}#{%( aria-label="#{aria_label}") if aria_label}>#{text}</a>)
      end
    end

    # Similar to I18n.t: just ~18x faster using ~10x less memory
    # (@pagy_locale explicitly initialized in order to avoid warning)
    def pagy_t(key, **)
      Pagy::I18n.translate(key, locale: (@pagy_locale ||= nil), **)
    end

    include Frontend::Loader
  end
end
