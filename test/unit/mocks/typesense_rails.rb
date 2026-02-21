# frozen_string_literal: true

require 'pagy/classes/offset/search'

module MockTypesenseRails
  RESULTS = {
    '*' => (1..1000).map { |n| "doc-#{n}" },
    'a' => (1..1000).map { |n| "a-#{n}" },
    'b' => (1..1000).map { |n| "b-#{n}" }
  }.freeze

  class Results
    attr_reader :term, :options

    def initialize(term, options = {})
      @term    = term
      @options = options
      @page    = options[:page] || 1
      @limit   = options[:per_page] || 20
    end

    def raw_answer
      all_results = RESULTS[@term] || []
      offset      = (@page - 1) * @limit
      hits        = all_results[offset, @limit] || []

      {
        'found'          => all_results.size,
        'page'           => @page,
        'request_params' => { 'per_page' => @limit },
        'hits'           => hits
      }
    end
  end

  class Model
    extend Pagy::Search

    def self.search(term, _query_by = nil, options = {})
      Results.new(term, options)
    end
  end
end
