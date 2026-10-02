# frozen_string_literal: true

require_relative '../../modules/searcher'

class Pagy
  module RailsActiveSearchPaginator
    module_function

    def paginate(search, options)
      if search.is_a?(Search::Arguments) # Active mode
        Searcher.resolve(options)
        model, arguments, search_options, block, calls = search

        method          = options[:search_method] || RailsActiveSearch::DEFAULT[:search_method]
        # The chained calls build the ActiveSearch::Query, so they apply before executing it
        query           = Searcher.chain(model.send(method, *arguments, **search_options, &block), calls)
        results         = query.limit(options[:limit])
                               .offset(options[:limit] * (options[:page] - 1))
                               .results
        options[:count] = results.total

        [RailsActiveSearch.new(**options), results]
      else # Passive mode (ActiveSearch::Results)
        # TODO: use the public readers when ActiveSearch::Results will provide them
        limit           = search.instance_variable_get(:@limit)
        offset          = search.instance_variable_get(:@offset).to_i # nil when not set
        options[:limit] = limit
        options[:page]  = (offset / limit) + 1
        options[:count] = search.total

        RailsActiveSearch.new(**options)
      end
    end
  end
end
