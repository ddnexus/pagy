# frozen_string_literal: true

require_relative 'search_wrapper'

class Pagy
  # Add searchkick paginator
  module Paginators
    # Paginate from search object
    def pagy_searchkick(search, **options)
      if search.is_a?(Search::Arguments)
        # The search is the array of pagy_search arguments
        SearchWrapper.wrap(self, search, options) do
          model, term, search_options, block = search
          search_options[:per_page] = options[:limit]
          search_options[:page]     = options[:page]
          results                   = model.send(Searchkick::DEFAULT[:search_method], term || '*', **search_options, &block)
          options[:count]           = results.total_count
          [Searchkick.new(**options), results]
        end
      else
        # The search is a searchkick results object
        options[:limit] = search.options[:per_page]
        options[:page]  = search.options[:page]
        options[:count] = search.total_count
        Searchkick.new(**options)
      end
    end
  end
end
