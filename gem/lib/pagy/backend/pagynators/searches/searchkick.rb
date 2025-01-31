# frozen_string_literal: true

require_relative 'wrapper'

class Pagy
  Backend.module_eval do
    private

    # Paginate from search object
    def pagy_searchkick(search, **options)
      if search.is_a?(Search::Arguments)
        # The search is the array of pagy_search args from the model
        SearchWrapper.wrap(self, search, options) do
          # The wrapper is generic, but this block is specific for this search class
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
