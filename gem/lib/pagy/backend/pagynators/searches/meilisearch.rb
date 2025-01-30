# frozen_string_literal: true

require_relative 'wrapper'

class Pagy
  Backend.module_eval do
    private

    # Paginate from search object
    def pagy_meilisearch(search_obj, **opts)
      if search_obj.is_a?(Search::Arguments)
        # The search_obj is the array of pagy_search args from the model
        SearchWrapper.wrap(self, search_obj, opts) do
          # The wrapper is generic, but this block is specific for this search class
          model, term, options    = search_obj
          options[:hits_per_page] = opts[:limit]
          options[:page]          = opts[:page]
          results                 = model.send(Meilisearch::DEFAULT[:search_method], term, options)
          opts[:count]            = results.raw_answer['totalHits']
          [Meilisearch.new(**opts), results]
        end
      else
        # The search_obj is a meilisearch results object
        opts[:limit] = search_obj.raw_answer['hitsPerPage']
        opts[:page]  = search_obj.raw_answer['page']
        opts[:count] = search_obj.raw_answer['totalHits']
        Meilisearch.new(**opts)
      end
    end
  end
end
