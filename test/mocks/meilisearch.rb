# frozen_string_literal: true

require 'pagy/classes/offset/search'

module MockMeilisearch
  RESULTS = { 'a' => ('a-1'..'a-1000').to_a,
              'b' => ('b-1'..'b-1000').to_a }.freeze

  class Results
    attr_reader :options, :term

    def initialize(term, options = {})
      @term    = term
      @options = options
      @page    = options[:page] || 1
      @limit   = options[:hits_per_page] || 20
    end

    def raw_answer
      # Simulate fetching data slices
      all_results = RESULTS[@term] || []
      offset      = (@page - 1) * @limit
      hits        = all_results[offset, @limit] || []

      {
        'totalHits'   => all_results.size,
      'hitsPerPage' => @limit,
      'page'        => @page,
      'hits'        => hits,
      'totalPages'  => (all_results.size.to_f / @limit).ceil
      }
    end

    # Helper to access hits directly in tests if needed (mimics gem behavior)
    def hits
      raw_answer['hits']
    end
  end

  class Model
    extend Pagy::Search

    def self.ms_search(term, options = {})
      Results.new(term, options)
    end
  end
end
