# frozen_string_literal: true

require_relative 'wrapper'

class Pagy
  Backend.module_eval do
    private

    # Paginate from search object
    def pagy_searchkick(search_obj, **vars)
      search = Offset::Search::Searchkick
      if search_obj.is_a?(Offset::Search::Arguments)
        # The search_obj is the array of pagy_search args from the model
        SearchWrapper.wrap(self, search_obj, vars) do
          # The wrapper is generic, but this block is specific for this search class
          model, term, options, block = search_obj
          options[:per_page] = vars[:limit]
          options[:page]     = vars[:page]
          results            = model.send(search::DEFAULT[:search_method], term || '*', **options, &block)
          vars[:count]       = results.total_count
          [search.new(**vars), results]
        end
      else
        # The search_obj is a searchkick results object
        vars[:limit] = search_obj.options[:per_page]
        vars[:page]  = search_obj.options[:page]
        vars[:count] = search_obj.total_count
        search.new(**vars)
      end
    end
  end
end
