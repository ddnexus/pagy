# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/headers
# frozen_string_literal: true

require_relative '../helpers/url'
require_relative '../helpers/links'

class Pagy
  DEFAULT[:headers] = { page:  'current-page',
                        limit: 'page-items',
                        count: 'total-count',
                        pages: 'total-pages' }
  # Add specialized backend methods to add pagination response headers
  Backend.module_eval do
    private

    include Url
    include Links

    # Merge the pagy headers into the response.headers
    def pagy_headers_merge(pagy)
      response.headers.merge!(pagy_headers(pagy))
    end

    # Generate a hash of RFC-8288 compliant http headers
    def pagy_headers(pagy, **)
      # If it's not in the vars, the autoloading kicked-in after the object creation,
      # which means that no custom DEFAULT has been set, so we use the original
      headers = pagy.vars[:headers] || DEFAULT[:headers]
      { 'link' => pagy_link_header(pagy, **) }.tap do |hash|
        hash[headers[:page]]  = pagy.page.to_s if pagy.page && headers[:page]
        hash[headers[:limit]] = pagy.limit.to_s \
            if headers[:limit] && !(defined?(::Pagy::Offset::Calendar) && pagy.is_a?(Offset::Calendar::Unit))
        return hash if (defined?(::Pagy::Offset::Countless) && pagy.is_a?(Offset::Countless)) || \
                       (defined?(::Pagy::Keyset) && pagy.is_a?(Keyset))

        hash[headers[:pages]] = pagy.last.to_s if headers[:pages]
        hash[headers[:count]] = pagy.count.to_s if pagy.count && headers[:count] # count may be nil with Calendar
      end
    end

    def pagy_link_header(pagy, **)
      pagy_links(pagy, **, absolute: true).map { |key, link| %(<#{link}>; rel="#{key}") }.join(', ')
    end
  end
end
