# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/searchkick
# frozen_string_literal: true

require_relative '../offset/searchkick'
require_relative '../helpers/search'

class Pagy
  # Add specialized backend methods to paginate Searchkick::Results
  Backend.module_eval do
    private

    # Paginate from search object
    def pagy_searchkick(search_obj, **vars)
      if search_obj.is_a?(Search::Arguments)
        # search_obj is the array of pagy_search args from the model
        pagy_wrap_search(search_obj, vars) do
          model, term, options, block, *called = search_obj
          options[:per_page] = vars[:limit]
          options[:page]     = vars[:page]
          results            = model.send(Offset::Searchkick::DEFAULT[:search_method], term || '*', **options, &block)
          vars[:count]       = results.total_count
          [Offset::Searchkick.new(**vars), results, called]
        end
      else
        # search_obj is a searchkick results object
        vars[:limit] = search_obj.options[:per_page]
        vars[:page]  = search_obj.options[:page]
        vars[:count] = search_obj.total_count
        Offset::Searchkick.new(**vars)
      end
    end
  end
end
