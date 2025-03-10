# frozen_string_literal: true

require_relative '../../modules/searcher'

class Pagy
  module SearchkickPaginator
    module_function

    # Paginate from search object.
    def paginate(context, search, **options)
      context.instance_eval do
        if search.is_a?(Search::Arguments)
          # The search is the array of pagy_search arguments
          Searcher.wrap(self, search, options) do
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
end
