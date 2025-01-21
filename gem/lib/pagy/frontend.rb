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

    include Frontend::Loader
  end
end
