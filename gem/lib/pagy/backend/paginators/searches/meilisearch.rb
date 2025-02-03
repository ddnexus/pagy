# frozen_string_literal: true

require_relative 'wrapper'

class Pagy
  # Add meilisearch pagynator
  Backend.module_eval do
    private

    # Paginate from search object
    def pagy_meilisearch(search, **options)
      if search.is_a?(Search::Arguments)
        # The search is the array of pagy_search arguments
        SearchWrapper.wrap(self, search, options) do
          # The wrapper is generic, but this block is specific for this search class
          model, term, search_options    = search
          search_options[:hits_per_page] = options[:limit]
          search_options[:page]          = options[:page]
          results                        = model.send(Meilisearch::DEFAULT[:search_method], term, search_options)
          options[:count]                = results.raw_answer['totalHits']
          [Meilisearch.new(**options), results]
        end
      else
        # The search is a meilisearch results object
        options[:limit] = search.raw_answer['hitsPerPage']
        options[:page]  = search.raw_answer['page']
        options[:count] = search.raw_answer['totalHits']
        Meilisearch.new(**options)
      end
    end
  end
end
