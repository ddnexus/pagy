# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/headers
# frozen_string_literal: true

require 'pagy/url_helpers'

class Pagy
  VARS[:headers] = { page: 'Current-Page', items: 'Page-Items', count: 'Total-Count', pages: 'Total-Pages' }
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
      pagy_headers_hash(pagy).tap do |hash|
        hash['Link'] = hash['Link'].map { |rel, link| %(<#{link}>; rel="#{rel}") }.join(', ')
      end
    end

    # Generates a hash structure of the headers
    def pagy_headers_hash(pagy)
      countless             = defined?(Pagy::Countless) && pagy.is_a?(Pagy::Countless)
      rel                   = { 'first' => 1, 'prev' => pagy.prev, 'next' => pagy.next }
      rel['last']           = pagy.last unless countless
      url_str               = pagy_url_for(pagy, PAGE_PLACEHOLDER, absolute: true)
      link                  = rel.map do |r, num| # filter_map if ruby >=2.7
                                next unless num
                                [r, url_str.sub(PAGE_PLACEHOLDER, num.to_s)]
                              end.compact.to_h
      hash                  = { 'Link' => link }
      headers               = pagy.vars[:headers]
      hash[headers[:page]]  = pagy.page.to_s         if headers[:page]
      hash[headers[:items]] = pagy.vars[:items].to_s if headers[:items]
      unless countless
        hash[headers[:pages]] = pagy.pages.to_s if headers[:pages]
        hash[headers[:count]] = pagy.count.to_s if headers[:count]
      end
      hash
    end
  end
  Backend.prepend HeadersExtra
end
