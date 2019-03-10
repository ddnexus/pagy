# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/headers
# encoding: utf-8
# frozen_string_literal: true

class Pagy
  # Add specialized backend methods to add pagination response headers
  module Backend ; private

    include Helpers

    def pagy_headers_merge(pagy)
      response.headers.merge!(pagy_headers(pagy))
    end

    def pagy_headers(pagy)
      hash = pagy_headers_hash(pagy)
      { 'Links'    => hash[:links].map{|rel, link| %(<#{link}>; rel="#{rel}")}.join(', ') }.tap do |h|
        h['Items'] = h['Per-Page'] = hash[:items]
        h['Count'] = h['Total']    = hash[:count] if hash.key?(:count)
      end
    end

    def pagy_headers_hash(pagy)
      countless = defined?(Pagy::Countless) && pagy.is_a?(Pagy::Countless)
      rels      = { first: 1, prev: pagy.prev, next: pagy.next }.tap{ |r| r[:last] = pagy.last unless countless }
      a, b      = pagy_url_for(Frontend::MARKER, pagy, :url).split(Frontend::MARKER, 2)
      links     = Hash[rels.map{|rel, n|[rel, "#{a}#{n}#{b}"] if n}.compact]
      { links: links }.tap do |h|
        h[:items] = h[:per_page] = pagy.vars[:items]
        h[:count] = h[:total]    = pagy.count unless countless
      end
    end

  end
end
