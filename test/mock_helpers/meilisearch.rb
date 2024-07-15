# frozen_string_literal: true

require 'pagy/extras/meilisearch'

module MockMeilisearch
  RESULTS = { 'a' => ('a-1'..'a-1000').to_a,
              'b' => ('b-1'..'b-1000').to_a }.freeze

  class Results < Array
    def initialize(query, params = {})
      @query = query
      @params = { page: 1, hits_per_page: 10 }.merge(params)

      super(RESULTS[@query].slice(@params[:hits_per_page] * ((@params[:page] || 1) - 1), @params[:hits_per_page]) || [])
    end

    def raw_answer
      {
        'hits'        => self,
        'hitsPerPage' => @params[:hits_per_page],
        'page'        => @params[:page],
        'totalHits'   => RESULTS[@query].length
      }
    end
  end

  class Model
    def self.ms_search(*args)
      Results.new(*args)
    end

    extend Pagy::Meilisearch
  end
end
