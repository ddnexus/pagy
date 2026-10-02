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
    def initialize(query, prefix: nil, limit: 10, offset: nil, conditions: [], order: nil)
      @query      = query
      @prefix     = prefix
      @limit      = limit
      @offset     = offset
      @conditions = conditions
      @order      = order
    end

    def limit(value)  = spawn(limit: value)
    def offset(value) = spawn(offset: value)
    # Keep the entries ending with the :suffix (e.g., filter(suffix: '5'))
    def filter(conditions) = spawn(conditions: [*@conditions, conditions[:suffix]])
    def sort(value) = spawn(order: value)

    def results
      entries = RESULTS[@query].select { |r| @conditions.all? { |suffix| r.end_with?(suffix) } }
      entries = entries.reverse if @order == :desc
      Results.new(entries.map { |r| "#{@prefix}#{r}" }, limit: @limit, offset: @offset)
    end

    private

    def spawn(**changes)
      Query.new(@query, prefix: @prefix, limit: @limit, offset: @offset, conditions: @conditions, order: @order, **changes)
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
