# frozen_string_literal: true

require 'pagy/extras/meilisearch'

module MockMeilisearch

  RESULTS = { 'a' => ('a-1'..'a-1000').to_a,
              'b' => ('b-1'..'b-1000').to_a }.freeze

  class Results < Array

    def initialize(query, params = {})
      @query = query
      @params = { offset: 0, limit: 10_000 }.merge(params)
      super RESULTS[@query].slice(@params[:offset], @params[:limit]) || []
    end

    def raw_answer
      {
        hits: self,
        offset: @params[:offset],
        limit: @params[:limit],
        nbHits: RESULTS[@query].length
      }
    end
  end

  class Model

    def self.search(*args)
      Results.new(*args)
    end

    extend Pagy::Meilisearch
  end
end
