# frozen_string_literal: true

module MockSearchkick
  RESULTS = { 'a' => ('a-1'..'a-1000').to_a,
              'b' => ('b-1'..'b-1000').to_a }.freeze

  class Results
    attr_reader :options

    def initialize(query, options = {}, &block)
      query    = 'a' if query == '*' # testing default query with the actual Model.search
      @entries = RESULTS[query]
      @options = { page: 1, per_page: 10 }.merge(options)
      from     = @options[:per_page] * ((@options[:page] || 1) - 1)
      results  = @entries[from, @options[:per_page]]
      addition = yield if block
      @results = results&.map { |r| "#{addition}#{r}" }
    end

    def results
      @results.map { |r| "R-#{r}" }
    end
    alias records results      # enables loops in limit_test

    def total_count
      @entries.size
    end
  end

  class Model
    def self.search(...)
      Results.new(...)
    end

    extend Pagy::Offset::Search
  end
end
