# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/headers
# encoding: utf-8
# frozen_string_literal: true

class Pagy
  # Add specialized backend methods to add pagination response headers
  module Backend ; private

    VARS[:headers] = { page: 'Current-Page', items: 'Page-Items', count: 'Total-Count', pages: 'Total-Pages' }

    include Helpers

    def pagy_headers_merge(pagy)
      response.headers.merge!(pagy_headers(pagy))
    end

    def pagy_headers(pagy)
      hash = pagy_headers_hash(pagy)
      hash['Link'] = hash['Link'].map{|rel, link| %(<#{link}>; rel="#{rel}")}.join(', ')
      hash
    end

    def pagy_headers_hash(pagy)
      countless = defined?(Pagy::Countless) && pagy.is_a?(Pagy::Countless)
      rels      = { 'first' => 1, 'prev' => pagy.prev, 'next' => pagy.next }; rels['last'] = pagy.last unless countless
      url_str   = pagy_url_for(Frontend::MARK, pagy, :url)
      hash      = { 'Link' => Hash[rels.map{|rel, n|[rel, url_str.sub(Frontend::MARK, n.to_s)] if n}.compact] }
      headers   = pagy.vars[:headers]
      hash[headers[:page]]  = pagy.page         if headers[:page]
      hash[headers[:items]] = pagy.vars[:items] if headers[:items]
      unless countless
        hash[headers[:pages]] = pagy.pages if headers[:pages]
        hash[headers[:count]] = pagy.count if headers[:count]
      end
      hash
    end

  end
end
