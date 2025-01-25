# frozen_string_literal: true

class Pagy
  module SearchWrapper
    module_function

    def wrap(backend, pagy_search_args, vars)
      backend.instance_exec do
        vars[:page]  ||= pagy_get_page(vars)
        vars[:limit] ||= pagy_get_limit(vars)
      end
      pagy, response = yield
      # The `{ }range_rescue: :last_page }` requires rerunning the method to retrieve the hits.
      if pagy.range_rescued? && pagy.vars[:range_rescue] == :last_page
        return backend.send(caller_locations(1, 1)[0].base_label, pagy_search_args, **vars, page: pagy.page)
      end

      calling = pagy_search_args[4..]
      [pagy, calling.empty? ? response : response.send(*calling)]
    end
  end
end
