require 'pagy/extras/elasticsearch_rails'

module ElasticsearchRailsTest

  RESULTS = { 'a' => ('a-1'..'a-1000').to_a,
              'b' => ('b-1'..'b-1000').to_a }

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
      @raw_response['hits']['hits'].map{|r| "R-#{r}"}
    end

    def count
      @raw_response['hits']['hits'].size
    end

  end
end

class ElasticsearchRailsModel

  def self.search(*args)
    ElasticsearchRailsTest::Response.new(*args)
  end

  extend Pagy::Search

end
