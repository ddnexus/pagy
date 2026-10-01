# frozen_string_literal: true

require 'pagy/classes/offset/search'

# Mimics the chainable ActiveSearch API: Model.search -> Query#limit/offset -> Results
module MockRailsActiveSearch
  RESULTS = { 'a' => ('a-1'..'a-1000').to_a,
              'b' => ('b-1'..'b-1000').to_a }.freeze

  class Results
    include Enumerable

    attr_reader :total

    # Like ActiveSearch::Results, it keeps limit and offset without public readers
    def initialize(entries, limit:, offset:)
      @total   = entries.size
      @limit   = limit
      @offset  = offset
      @records = entries[offset.to_i, limit] || []
    end

    def each(&) = @records.each(&)
  end

  class Query
    def initialize(query, prefix: nil, limit: 10, offset: nil)
      @query  = query
      @prefix = prefix
      @limit  = limit
      @offset = offset
    end

    def limit(value)  = Query.new(@query, prefix: @prefix, limit: value, offset: @offset)
    def offset(value) = Query.new(@query, prefix: @prefix, limit: @limit, offset: value)

    def results
      entries = RESULTS[@query].map { |r| "#{@prefix}#{r}" }
      Results.new(entries, limit: @limit, offset: @offset)
    end
  end

  class Model
    extend Pagy::Search

    def self.search(query = nil, prefix: nil, &block)
      prefix = "#{prefix}#{yield if block}"
      Query.new(query || 'a', prefix:)
    end
  end
end
