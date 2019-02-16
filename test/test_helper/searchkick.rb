require 'pagy/extras/searchkick'

module SearchkickTest

  RESULTS = { 'a' => ('a-1'..'a-1000').to_a,
              'b' => ('b-1'..'b-1000').to_a }

  class Results

    attr_reader :options

    def initialize(query, options={}, &block)
      @entries = RESULTS[query]
      @options = {page: 1, per_page: 10_000}.merge(options)
      from     = @options[:per_page] * (@options[:page] - 1)
      results  = @entries[from, @options[:per_page]]
      addition = yield if block
      @results = results.map{|r| "#{addition}#{r}"}
    end

    def results
      @results.map{|r| "R-#{r}"}
    end
    alias :records :results      # enables loops in items_test

    def total_count
      @entries.size
    end

  end
end

class SearchkickModel

  def self.search(*args, &block)
    SearchkickTest::Results.new(*args, &block)
  end

  extend Pagy::Search
end
