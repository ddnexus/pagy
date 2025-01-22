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
      # Skip if pagy_calendar_counts is defined
      if (counts = pagy.vars[:calendar_counts])
        count_info = lambda do |page, classes|
                       count    = counts[page - 1]
                       info_key = count.zero? ? 'pagy.info.no_items' : 'pagy.info.single_page'
                       classes  = classes ? "#{classes} empty-page" : 'empty-page' if count.zero?
                       title    = %( title="#{pagy_t(info_key, item_name: pagy_t('pagy.item_name', count:), count:)}")
                       [classes, title]
                     end
      end
      left, right =
        %(<a#{%( #{anchor_string}) if anchor_string} href="#{pagy_page_url(pagy, PAGE_TOKEN, **vars)}").split(PAGE_TOKEN, 2)
      # lambda used by all the helpers
      lambda do |page, text = pagy.label(page: page), classes: nil, aria_label: nil|
        classes, title = count_info.(page, classes) if count_info
        %(#{left}#{page}#{right}#{title}#{%( class="#{classes}") if classes}#{
          %( aria-label="#{aria_label}") if aria_label}>#{text}</a>)
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
