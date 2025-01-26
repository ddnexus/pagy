# frozen_string_literal: true

require_relative 'wrapper'

class Pagy
  Backend.module_eval do
    private

    # Paginate from search object
    def pagy_elasticsearch_rails(search_obj, **vars)
      if search_obj.is_a?(Search::Arguments)
        # The search_obj is the array of pagy_search args from the model
        SearchWrapper.wrap(self, search_obj, vars) do
          # The wrapper is generic, but this block is specific for this search class
          model, query_or_payload, options = search_obj
          options[:size] = vars[:limit]
          options[:from] = vars[:limit] * ((vars[:page] || 1) - 1)
          results        = model.send(ElasticsearchRails::DEFAULT[:search_method], query_or_payload, **options)
          vars[:count]   = ElasticsearchRails.total_count(results)
          [ElasticsearchRails.new(**vars), results]
        end
      else
        # The search_obj is an elasticsearch_rails response
        vars[:limit] = search_obj.search.options[:size] || 10
        vars[:page]  = ((search_obj.search.options[:from] || 0) / vars[:limit]) + 1
        vars[:count] = ElasticsearchRails.total_count(search_obj)
        ElasticsearchRails.new(**vars)
      end
    end
  end
end
