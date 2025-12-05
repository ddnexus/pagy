# frozen_string_literal: true

# No need to use all the UI in the tests, but goot to have the extra possibility
module MockElasticsearchRails
  RESULTS = { 'a' => ('a-1'..'a-1000').to_a,
              'b' => ('b-1'..'b-1000').to_a }.freeze

  class DslSearch
    def initialize(hash)
      @hash = hash
    end

    def to_hash
      @hash
    end
  end

  class Search
    attr_reader :options, :results, :definition

    def initialize(query, options = {})
      @definition = query
      @options    = options

      def_hash = if query.respond_to?(:to_hash)
                   query.to_hash
                 elsif query.is_a?(Hash)
                   query
                 else
                   {}
                 end

      container = def_hash[:body] || def_hash
      from      = container[:from] || options[:from] || 0
      size      = container[:size] || options[:size] || 10

      data_key = query.is_a?(String) && RESULTS.key?(query) ? query : 'a'
      @results = RESULTS[data_key][from.to_i, size.to_i]
    end
  end

  class Response
    attr_reader :search, :raw_response

    def initialize(query, options = {})
      @search = Search.new(query, options)
      key = query.is_a?(String) && RESULTS.key?(query) ? query : 'a'
      @raw_response = { 'hits' => { 'hits' => @search.results, 'total' => RESULTS[key].size } }
    end

    def records
      @raw_response['hits']['hits'].map { |r| "R-#{r}" }
    end
  end

  class Model
    def self.search(query, options = {})
      Response.new(query, options)
    end

    extend Pagy::Search
  end

  class ResponseES7 < Response
    def initialize(query, options = {})
      super
      key = query.is_a?(String) && RESULTS.key?(query) ? query : 'a'
      @raw_response = { 'hits' => { 'hits' => @search.results, 'total' => { 'value' => RESULTS[key].size } } }
    end
  end

  class ModelES7 < Model
    def self.search(query, options = {})
      ResponseES7.new(query, options)
    end
  end

  class ResponseES5
    attr_reader :search, :response

    def initialize(query, options = {})
      @search = Search.new(query, options)
      key = query.is_a?(String) && RESULTS.key?(query) ? query : 'a'
      @response = { 'hits' => { 'hits' => @search.results, 'total' => RESULTS[key].size } }
    end

    def [](key)
      @response[key]
    end
  end

  class ModelES5 < Model
    def self.search(query, options = {})
      ResponseES5.new(query, options)
    end
  end
end
