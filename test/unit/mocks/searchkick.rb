# frozen_string_literal: true

require 'pagy/classes/offset/search'

module MockSearchkick
  RESULTS = { 'a' => ('a-1'..'a-1000').to_a,
              'b' => ('b-1'..'b-1000').to_a }.freeze

  class Results
    attr_reader :options

    def initialize(query, options = {}, &block)
      query    = 'a' if query == '*' # testing the default query with the actual Model.search
      @entries = RESULTS[query]
      @options = { page: 1, per_page: 10 }.merge(options)
      from     = @options[:per_page] * ((@options[:page] || 1) - 1)
      results  = @entries[from, @options[:per_page]]
      addition = yield if block
      @results = results.map { |r| "#{addition}#{r}" }
    end

    def results
      @results.map { |r| "R-#{r}" }
    end
    alias records results

    def total_count
      @entries.size
    end
  end

  class ResultsV6 < Results
    undef_method :options

    def per_page
      @options[:per_page]
    end

    def current_page
      @options[:page]
    end
  end

  class Model
    def self.search(...)
      Results.new(...)
    end

    extend Pagy::Search
  end

  class ModelV6
    def self.search(...)
      ResultsV6.new(...)
    end

    extend Pagy::Search
  end
end
