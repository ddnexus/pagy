# frozen_string_literal: true

require_relative 'wrapper'

class Pagy
  Backend.module_eval do
    private

    # Paginate from search object
    def pagy_elasticsearch_rails(search_obj, **vars)
      search = Offset::Search::ElasticsearchRails
      if search_obj.is_a?(Offset::Search::Arguments)
        # The search_obj is the array of pagy_search args from the model
        SearchWrapper.wrap(self, search_obj, vars) do
          # The wrapper is generic, but this block is specific for this search class
          model, query_or_payload, options, _block, *called = search_obj
          options[:size] = vars[:limit]
          options[:from] = vars[:limit] * ((vars[:page] || 1) - 1)
          results        = model.send(search::DEFAULT[:search_method], query_or_payload, **options)
          vars[:count]   = search.total_count(results)
          [search.new(**vars), results, called]
        end
      else
        # The search_obj is an elasticsearch_rails response
        vars[:limit] = search_obj.search.options[:size] || 10
        vars[:page]  = ((search_obj.search.options[:from] || 0) / vars[:limit]) + 1
        vars[:count] = search.total_count(search_obj)
        search.new(**vars)
      end
    end
  end
end
