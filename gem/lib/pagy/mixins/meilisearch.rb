# frozen_string_literal: true

require_relative '../offset/meilisearch'
require_relative '../helpers/search'

class Pagy
  Backend.module_eval do
    private

    # Paginate from search object
    def pagy_meilisearch(search_obj, **vars)
      if search_obj.is_a?(Search::Arguments)
        # search_obj is the array of pagy_search args from the model
        pagy_wrap_search(search_obj, vars) do
          model, term, options    = search_obj
          options[:hits_per_page] = vars[:limit]
          options[:page]          = vars[:page]
          results                 = model.send(Offset::Meilisearch::DEFAULT[:search_method], term, options)
          vars[:count]            = results.raw_answer['totalHits']
          [Offset::Meilisearch.new(**vars), results]
        end
      else
        # search_obj is a meilisearch results object
        vars[:limit] = search_obj.raw_answer['hitsPerPage']
        vars[:page]  = search_obj.raw_answer['page']
        vars[:count] = search_obj.raw_answer['totalHits']
        Offset::Meilisearch.new(**vars)
      end
    end
  end
end
