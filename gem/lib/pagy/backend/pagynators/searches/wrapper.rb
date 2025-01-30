# frozen_string_literal: true

class Pagy
  module SearchWrapper
    module_function

    def wrap(backend, pagy_search_args, opts)
      backend.instance_exec do
        opts[:page]  ||= pagy_get_page(opts)
        opts[:limit] ||= pagy_get_limit(opts)
      end
      pagy, results = yield
      calling = pagy_search_args[4..]
      [pagy, calling.empty? ? results : results.send(*calling)]
    end
  end
end
