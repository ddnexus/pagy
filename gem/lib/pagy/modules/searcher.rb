# frozen_string_literal: true

class Pagy
  # Relegate internal functions. Make overriding search classes easier.
  module Searcher
    module_function

    # Common search logic
    def wrap(context, pagy_search_args, options)
      context.instance_exec do
        options[:request] = Request.new(options[:request] || request, options)
        options[:page]  ||= options[:request].page(options)
        options[:limit] ||= options[:request].limit(options)
      end
      pagy, results = yield
      calling = pagy_search_args[4..]
      [pagy, calling.empty? ? results : results.send(*calling)]
    end
  end
end
