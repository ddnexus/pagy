# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/searchkick
# frozen_string_literal: true

require_relative '../offset/searchkick'
require_relative '../helpers/search'

class Pagy
  # Add specialized backend methods to paginate Searchkick::Results
  Backend.module_eval do
    private

    # Return Pagy object and results
    def pagy_searchkick(pagy_search_args, **vars)
      pagy_wrap_search(pagy_search_args, vars) do
        model, term, options, block, *called = pagy_search_args
        options[:per_page] = vars[:limit]
        options[:page]     = vars[:page]
        results            = model.send(Offset::Searchkick::DEFAULT[:search_method], term || '*', **options, &block)
        vars[:count]       = results.total_count
        [Offset::Searchkick.new(**vars), results, called]
      end
    end
  end
end
