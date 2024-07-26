# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/meilisearch
# frozen_string_literal: true

class Pagy # :nodoc:
  DEFAULT[:meilisearch_search]      ||= :ms_search
  DEFAULT[:meilisearch_pagy_search] ||= :pagy_search

  # Paginate Meilisearch results
  module MeilisearchExtra
    module ModelExtension # :nodoc:
      # Return an array used to delay the call of #search
      # after the pagination variables are merged to the options
      def pagy_meilisearch(query, params = {})
        [self, query, params]
      end
      alias_method DEFAULT[:meilisearch_pagy_search], :pagy_meilisearch
    end
    Pagy::Meilisearch = ModelExtension

    # Extension for the Pagy class
    module PagyExtension
      # Create a Pagy object from a Meilisearch results
      def new_from_meilisearch(results, **vars)
        vars[:limit] = results.raw_answer['hitsPerPage']
        vars[:page]  = results.raw_answer['page']
        vars[:count] = results.raw_answer['totalHits']

        new(**vars)
      end
    end
    Pagy.extend PagyExtension

    # Add specialized backend methods to paginate Meilisearch results
    module BackendAddOn
      private

      # Return Pagy object and results
      def pagy_meilisearch(pagy_search_args, **vars)
        vars[:page]  ||= (pagy_get_page(vars) || 1).to_i
        vars[:limit] ||= pagy_get_limit(vars)
        model, term, options    = pagy_search_args
        options[:hits_per_page] = vars[:limit]
        options[:page]          = vars[:page]
        results                 = model.send(:ms_search, term, options)
        vars[:count]            = results.raw_answer['totalHits']

        pagy                    = ::Pagy.new(**vars)
        # with :last_page overflow we need to re-run the method in order to get the hits
        return pagy_meilisearch(pagy_search_args, **vars, page: pagy.page) \
               if defined?(::Pagy::OverflowExtra) && pagy.overflow? && pagy.vars[:overflow] == :last_page

        [pagy, results]
      end
    end
    Backend.prepend BackendAddOn
  end
end
