# frozen_string_literal: true

require 'pagy/extras/elasticsearch_rails'

module MockElasticsearchRails

  RESULTS = { 'a' => ('a-1'..'a-1000').to_a,
              'b' => ('b-1'..'b-1000').to_a }.freeze

  class Search

    attr_reader :options, :results

     def initialize(query, options={})
       @options = options
       @results = RESULTS[query][@options[:from]||0,@options[:size]||10]
     end

  end

  class Response

    attr_reader :search, :raw_response

    def initialize(query, options={})
      @search = Search.new(query, options)
      @raw_response = {'hits' => {'hits' => @search.results, 'total' => RESULTS[query].size}}
    end

    def records
      @raw_response['hits']['hits'].map { |r| "R-#{r}" }
    end

    # unused by current testing
    # def count
    #   @raw_response['hits']['hits'].size
    # end

  end

  class Model

    def self.search(*args)
      Response.new(*args)
    end

    extend Pagy::ElasticsearchRails
  end

  class ResponseES7 < Response

    def initialize(query, options={})
      super(query, options)
      @raw_response = {'hits' => {'hits' => @search.results, 'total' => {'value' => RESULTS[query].size}}}
    end

  end

  class ModelES7 < Model

    def self.search(*args)
      ResponseES7.new(*args)
    end

  end

  class ResponseES5

    attr_reader :search, :response

    def initialize(query, options={})
      @search = Search.new(query, options)
      @response = {'hits' => {'hits' => @search.results, 'total' => RESULTS[query].size}}
    end

    # unused by current testing
    # def records
    #   @response['hits']['hits'].map { |r| "R-#{r}" }
    # end
    #
    # def count
    #   @response['hits']['hits'].size
    # end

  end

  class ModelES5 < Model

    def self.search(*args)
      ResponseES5.new(*args)
    end

  end
end
