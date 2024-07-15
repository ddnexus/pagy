# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/headers
# frozen_string_literal: true

require_relative '../url_helpers'

class Pagy # :nodoc:
  DEFAULT[:headers] = { page:  'current-page',
                        items: 'page-items',
                        count: 'total-count',
                        pages: 'total-pages' }
  # Add specialized backend methods to add pagination response headers
  module HeadersExtra
    include UrlHelpers

    private

    # Merge the pagy headers into the response.headers
    def pagy_headers_merge(pagy)
      response.headers.merge!(pagy_headers(pagy))
    end

    # Generate a hash of RFC-8288 compliant http headers
    def pagy_headers(pagy)
      headers = pagy.vars[:headers]
      { 'link' => link(pagy) }.tap do |hash|
        hash[headers[:page]]  = pagy.page.to_s if pagy.page && headers[:page]
        hash[headers[:items]] = pagy.items.to_s \
            if headers[:items] && !(defined?(Calendar) && pagy.is_a?(Calendar::Unit))
        return hash if (defined?(Countless) && pagy.is_a?(Countless)) || \
                       (defined?(Keyset) && pagy.is_a?(Keyset))

        hash[headers[:pages]] = pagy.last.to_s if headers[:pages]
        hash[headers[:count]] = pagy.count.to_s if pagy.count && headers[:count] # count may be nil with Calendar
      end
    end

    def link(pagy)
      [].tap do |link|
        if defined?(Keyset) && pagy.is_a?(Keyset)
          link << %(<#{pagy_url_for(pagy, nil, absolute: true)}>; rel="first")
          link << %(<#{pagy_url_for(pagy, pagy.next, absolute: true)}>; rel="next") if pagy.next
        else
          url_str = pagy_url_for(pagy, PAGE_TOKEN, absolute: true)
          link << %(<#{url_str.sub(PAGE_TOKEN, '1')}>; rel="first")
          link << %(<#{url_str.sub(PAGE_TOKEN, pagy.prev.to_s)}>; rel="prev") if pagy.prev
          link << %(<#{url_str.sub(PAGE_TOKEN, pagy.next.to_s)}>; rel="next") if pagy.next
          link << %(<#{url_str.sub(PAGE_TOKEN, pagy.last.to_s)}>; rel="last") \
              unless defined?(Countless) && pagy.is_a?(Countless)
        end
      end.join(', ')
    end
  end
  Backend.prepend HeadersExtra
end
