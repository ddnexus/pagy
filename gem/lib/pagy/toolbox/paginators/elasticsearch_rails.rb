# frozen_string_literal: true

require_relative '../../modules/searcher'

class Pagy
  module ElasticsearchRailsPaginator
    module_function

    # Paginate from the search object
    def paginate(context, search, **options)
      context.instance_eval do
        options[:request] = Request.new(options[:request] || request, options)
        if search.is_a?(Search::Arguments)
          # The search is the array of pagy_search arguments
          Searcher.wrap(self, search, options) do
            model, query_or_payload, search_options = search
            search_options[:size] = options[:limit]
            search_options[:from] = options[:limit] * ((options[:page] || 1) - 1)
            results               = model.send(ElasticsearchRails::DEFAULT[:search_method], query_or_payload, **search_options)
            options[:count]       = ElasticsearchRails.total_count(results)
            [ElasticsearchRails.new(**options), results]
          end
        else
          # The search is an elasticsearch_rails response
          options[:limit] = search.search.options[:size] || 10
          options[:page]  = ((search.search.options[:from] || 0) / options[:limit]) + 1
          options[:count] = ElasticsearchRails.total_count(search)
          ElasticsearchRails.new(**options)
        end
      end
    end
  end
end
