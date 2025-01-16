# frozen_string_literal: true

require_relative '../../offset/search'
require_relative 'wrapper'

class Pagy
  Backend.module_eval do
    private

    # Paginate from search object
    def pagy_meilisearch(search_obj, **vars)
      search = Offset::Search::Meilisearch
      if search_obj.is_a?(Offset::Search::Arguments)
        # The search_obj is the array of pagy_search args from the model
        pagy_wrap_search(search_obj, vars) do
          model, term, options    = search_obj
          options[:hits_per_page] = vars[:limit]
          options[:page]          = vars[:page]
          results                 = model.send(search::DEFAULT[:search_method], term, options)
          vars[:count]            = results.raw_answer['totalHits']
          [search.new(**vars), results]
        end
      else
        # The search_obj is a meilisearch results object
        vars[:limit] = search_obj.raw_answer['hitsPerPage']
        vars[:page]  = search_obj.raw_answer['page']
        vars[:count] = search_obj.raw_answer['totalHits']
        search.new(**vars)
      end
    end
  end
end
