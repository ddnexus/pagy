# frozen_string_literal: true

class Pagy
  module SearchWrapper
    module_function

    def wrap(backend, pagy_search_args, vars)
      backend.instance_exec do
        vars[:page]  ||= pagy_get_page(vars)
        vars[:limit] ||= pagy_get_limit(vars)
      end
      pagy, results = yield
      calling = pagy_search_args[4..]
      [pagy, calling.empty? ? results : results.send(*calling)]
    end
  end
end
