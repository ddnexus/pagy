# frozen_string_literal: true

require_relative 'wrapper'

class Pagy
  Backend.module_eval do
    private

    # Paginate from search object
    def pagy_searchkick(search_obj, **opts)
      if search_obj.is_a?(Search::Arguments)
        # The search_obj is the array of pagy_search args from the model
        SearchWrapper.wrap(self, search_obj, opts) do
          # The wrapper is generic, but this block is specific for this search class
          model, term, options, block = search_obj
          options[:per_page] = opts[:limit]
          options[:page]     = opts[:page]
          results            = model.send(Searchkick::DEFAULT[:search_method], term || '*', **options, &block)
          opts[:count]       = results.total_count
          [Searchkick.new(**opts), results]
        end
      else
        # The search_obj is a searchkick results object
        opts[:limit] = search_obj.options[:per_page]
        opts[:page]  = search_obj.options[:page]
        opts[:count] = search_obj.total_count
        Searchkick.new(**opts)
      end
    end
  end
end
