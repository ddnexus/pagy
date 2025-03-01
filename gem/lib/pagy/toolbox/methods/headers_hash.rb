# frozen_string_literal: true

require_relative 'links_hash'

# Add pagination response headers
class Pagy
  # Generate a hash of RFC-8288-compliant http headers
  def headers_hash(headers_map: @options[:headers_map] ||
    { page: 'current-page', limit: 'page-limit', count: 'total-count', pages: 'total-pages' }, **)
    links = links_hash(**, absolute: true).map { |key, link| %(<#{link}>; rel="#{key}") }.join(', ')
    { 'link' => links }.tap do |hash|
      hash[headers_map[:page]]  = @page.to_s if @page && headers_map[:page]
      hash[headers_map[:limit]] = @limit.to_s if headers_map[:limit] && !calendar?
      return hash unless @count

      hash[headers_map[:pages]] = @last.to_s if headers_map[:pages]
      hash[headers_map[:count]] = @count.to_s if headers_map[:count]
    end
  end
end
