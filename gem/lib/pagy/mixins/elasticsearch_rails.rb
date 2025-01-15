# frozen_string_literal: true

require_relative '../offset/elasticsearch_rails'
require_relative '../helpers/search'

class Pagy
  Backend.module_eval do
    private

    # Paginate from search object
    def pagy_elasticsearch_rails(search_obj, **vars)
      if search_obj.is_a?(Search::Arguments)
        # search_obj is the array of pagy_search args from the model
        pagy_wrap_search(search_obj, vars) do
          model, query_or_payload, options, _block, *called = search_obj
          options[:size] = vars[:limit]
          options[:from] = vars[:limit] * ((vars[:page] || 1) - 1)
          Offset::ElasticsearchRails.class_eval do
            response     = model.send(self::DEFAULT[:search_method], query_or_payload, **options)
            vars[:count] = total_count(response)
            [new(**vars), response, called]
          end
        end
      else
        # search_obj is an elasticsearch_rails response
        vars[:limit] = search_obj.search.options[:size] || 10
        vars[:page]  = ((search_obj.search.options[:from] || 0) / vars[:limit]) + 1
        vars[:count] = Offset::ElasticsearchRails.total_count(search_obj)
        Offset::ElasticsearchRails.new(**vars)
      end
    end
  end
end
