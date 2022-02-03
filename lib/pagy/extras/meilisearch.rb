# frozen_string_literal: true

class Pagy # :nodoc:
  DEFAULT[:meilisearch_search]      ||= :search
  DEFAULT[:meilisearch_pagy_search] ||= if DEFAULT[:meilisearch_search_method]   # remove in 6.0
                                          # :nocov:
                                          Warning.warn '[PAGY WARNING] The :meilisearch_search_method variable ' \
                                                       'has been deprecated and will be ignored from pagy 6. ' \
                                                       'Use :meilisearch_pagy_search instead.'
                                          DEFAULT[:meilisearch_search_method]
                                          # :nocov:
                                        else
                                          :pagy_search
                                        end
  # Paginate Meilisearch results
  module MeilisearchExtra
    module Meilisearch # :nodoc:
      # Return an array used to delay the call of #search
      # after the pagination variables are merged to the options
      def pagy_meilisearch(term = nil, **vars)
        [self, term, vars]
      end
      alias_method DEFAULT[:meilisearch_pagy_search], :pagy_meilisearch
    end

    # Additions for the Pagy class
    module Pagy
      # Create a Pagy object from a Meilisearch results
      def new_from_meilisearch(results, vars = {})
        vars[:items] = results.raw_answer['limit']
        vars[:page]  = (results.raw_answer['offset'] / vars[:items]) + 1
        vars[:count] = results.raw_answer['nbHits']
        new(vars)
      end
    end

    # Add specialized backend methods to paginate Meilisearch results
    module Backend
      private

      # Return Pagy object and results
      def pagy_meilisearch(pagy_search_args, vars = {})
        model, term, options = pagy_search_args
        vars                 = pagy_meilisearch_get_vars(nil, vars)
        options[:limit]      = vars[:items]
        options[:offset]     = (vars[:page] - 1) * vars[:items]
        results              = model.send(DEFAULT[:meilisearch_search], term, **options)
        vars[:count]         = results.raw_answer['nbHits']
        pagy                 = ::Pagy.new(vars)
        # with :last_page overflow we need to re-run the method in order to get the hits
        return pagy_meilisearch(pagy_search_args, vars.merge(page: pagy.page)) \
               if defined?(::Pagy::OverflowExtra) && pagy.overflow? && pagy.vars[:overflow] == :last_page

        [pagy, results]
      end

      # Sub-method called only by #pagy_meilisearch: here for easy customization of variables by overriding.
      # The _collection argument is not available when the method is called.
      def pagy_meilisearch_get_vars(_collection, vars)
        pagy_set_items_from_params(vars) if defined?(ItemsExtra)
        vars[:items] ||= DEFAULT[:items]
        vars[:page]  ||= (params[vars[:page_param] || DEFAULT[:page_param]] || 1).to_i
        vars
      end
    end
  end
  Meilisearch = MeilisearchExtra::Meilisearch
  extend MeilisearchExtra::Pagy
  Backend.prepend MeilisearchExtra::Backend
end
