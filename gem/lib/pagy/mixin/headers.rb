# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/headers
# frozen_string_literal: true

require_relative '../url_helpers'

class Pagy
  DEFAULT[:headers] = { page:  'current-page',
                        limit: 'page-items',
                        count: 'total-count',
                        pages: 'total-pages' }
  # Add specialized backend methods to add pagination response headers
  module HeadersMixin
    include UrlHelpers

    private

    # Merge the pagy headers into the response.headers
    def pagy_headers_merge(pagy)
      response.headers.merge!(pagy_headers(pagy))
    end

    # Generate a hash of RFC-8288 compliant http headers
    def pagy_headers(pagy)
      headers = pagy.vars[:headers]
      pagy_link_header(pagy).tap do |hash|
        hash[headers[:page]]  = pagy.page.to_s if pagy.page && headers[:page]
        hash[headers[:limit]] = pagy.limit.to_s \
            if headers[:limit] && !(defined?(::Pagy::Offset::Calendar) && pagy.is_a?(Offset::Calendar::Unit))
        return hash if (defined?(::Pagy::Offset::Countless) && pagy.is_a?(Offset::Countless)) || \
                       (defined?(::Pagy::Keyset) && pagy.is_a?(Keyset))

        hash[headers[:pages]] = pagy.last.to_s if headers[:pages]
        hash[headers[:count]] = pagy.count.to_s if pagy.count && headers[:count] # count may be nil with Calendar
      end
    end

    def pagy_link_header(pagy)
      { 'link' => [].tap do |link|
        if defined?(::Pagy::Keyset) && pagy.is_a?(Keyset)
          link << %(<#{pagy_page_url(pagy, nil, absolute: true)}>; rel="first")
          link << %(<#{pagy_page_url(pagy, pagy.next, absolute: true)}>; rel="next") if pagy.next
        else
          p = PAGE_TOKEN
          url_str = pagy_page_url(pagy, PAGE_TOKEN, absolute: true)
          link << %(<#{url_str.sub(p, '1')}>; rel="first")
          link << %(<#{url_str.sub(p, pagy.prev.to_s)}>; rel="prev") if pagy.prev
          link << %(<#{url_str.sub(p, pagy.next.to_s)}>; rel="next") if pagy.next
          link << %(<#{url_str.sub(p, pagy.last.to_s)}>; rel="last") \
              unless defined?(::Pagy::Offset::Countless) && pagy.is_a?(Offset::Countless)
        end
      end.join(', ') }
    end
  end
  Backend.prepend HeadersMixin
end
