# frozen_string_literal: true

class Pagy
  # Relegate internal functions. Make overriding search classes easier.
  module SearchWrapper
    module_function

    # Common search logic
    def wrap(backend, pagy_search_args, options)
      backend.instance_exec do
        options[:request] ||= request
        options[:page]    ||= pagy_get_page(options)
        options[:limit]   ||= pagy_get_limit(options)
      end
      pagy, results = yield
      calling = pagy_search_args[4..]
      [pagy, calling.empty? ? results : results.send(*calling)]
    end
  end
end
