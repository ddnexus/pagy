# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/meilisearch
# frozen_string_literal: true

require_relative '../offset/meilisearch'

class Pagy
  # Model extension
  module Meilisearch
    # Return an array used to delay the call of #search
    # after the pagination variables are merged to the options
    def pagy_meilisearch(query, params = {})
      [self, query, params]
    end
    alias_method Offset::Meilisearch::DEFAULT[:meilisearch_pagy_search], :pagy_meilisearch
  end

  Backend.class_eval do
    # Return Pagy object and results
    def pagy_meilisearch(pagy_search_args, **vars)
      vars[:page]  ||= pagy_get_page(vars)
      vars[:limit] ||= pagy_get_limit(vars)
      model, term, options    = pagy_search_args
      options[:hits_per_page] = vars[:limit]
      options[:page]          = vars[:page]
      results                 = model.send(Offset::Meilisearch::DEFAULT[:meilisearch_search], term, options)
      vars[:count]            = results.raw_answer['totalHits']
      pagy                    = Offset::Meilisearch.new(**vars)
      # with :last_page overflow we need to re-run the method in order to get the hits
      if pagy.overflow? && pagy.vars[:overflow] == :last_page      # rubocop:disable Style/IfUnlessModifier
        return pagy_meilisearch(pagy_search_args, **vars, page: pagy.page)
      end

      [pagy, results]
    end
  end
end
