# frozen_string_literal: true

require_relative 'links'

class Pagy
  HEADER_NAMES = { page:  'current-page',
                   limit: 'page-items',
                   count: 'total-count',
                   pages: 'total-pages' }.freeze
  # Add specialized backend methods to add pagination response headers
  Backend.module_eval do
    private

    # Merge the pagy_headers into the response.headers
    def pagy_headers_merge(pagy)
      response.headers.merge!(pagy_headers(pagy))
    end

    # Generate a hash of RFC-8288-compliant http headers
    def pagy_headers(pagy, header_names: nil, **)
      headers = header_names || pagy.opts[:header_names] || HEADER_NAMES
      links   = pagy_links(pagy, **, absolute: true).map { |key, link| %(<#{link}>; rel="#{key}") }.join(', ')
      { 'link' => links }.tap do |hash|
        hash[headers[:page]]  = pagy.page.to_s if pagy.page && headers[:page]
        hash[headers[:limit]] = pagy.limit.to_s if headers[:limit] && !pagy.calendar?
        return hash unless pagy.count

        hash[headers[:pages]] = pagy.last.to_s if headers[:pages]
        hash[headers[:count]] = pagy.count.to_s if headers[:count]
      end
    end
  end
end
