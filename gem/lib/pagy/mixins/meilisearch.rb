# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/meilisearch
# frozen_string_literal: true

require_relative '../offset/meilisearch'
require_relative '../helpers/search'

class Pagy
  Backend.module_eval do
    # Return Pagy object and results
    def pagy_meilisearch(pagy_search_args, **vars)
      pagy_wrap_search(pagy_search_args, vars) do
        model, term, options    = pagy_search_args
        options[:hits_per_page] = vars[:limit]
        options[:page]          = vars[:page]
        results                 = model.send(Offset::Meilisearch::DEFAULT[:search_method], term, options)
        vars[:count]            = results.raw_answer['totalHits']
        [Offset::Meilisearch.new(**vars), results]
      end
    end
  end
end
