# frozen_string_literal: true

require_relative 'links_hash'

# Add pagination response headers
class Pagy
  # Generate a hash of RFC-8288-compliant http headers
  def headers_hash(header_names: nil, **)
    headers = header_names || @options[:header_names] || { page:  'current-page',
                                                           limit: 'page-items',
                                                           count: 'total-count',
                                                           pages: 'total-pages' }
    links = links_hash(**, absolute: true).map { |key, link| %(<#{link}>; rel="#{key}") }.join(', ')
    { 'link' => links }.tap do |hash|
      hash[headers[:page]]  = @page.to_s if @page && headers[:page]
      hash[headers[:limit]] = @limit.to_s if headers[:limit] && !calendar?
      return hash unless @count

      hash[headers[:pages]] = @last.to_s  if headers[:pages]
      hash[headers[:count]] = @count.to_s if headers[:count]
    end
  end
end
