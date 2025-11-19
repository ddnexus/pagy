# frozen_string_literal: true

class Pagy
  # Relegate internal functions. Make overriding search classes easier.
  module Searcher
    module_function

    # Common search logic
    def wrap(pagy_search_args, options)
      options[:page] ||= options[:request].resolve_page(options)
      options[:limit]  = options[:request].resolve_limit(options)
      pagy, results    = yield
      calling          = pagy_search_args[4..]
      [pagy, calling.empty? ? results : results.send(*calling)]
    end
  end
end
