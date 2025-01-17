# frozen_string_literal: true

class Pagy
  module SearchWrapper
    module_function

    def wrap(backend, pagy_search_args, vars)
      backend.instance_exec do
        vars[:page]  ||= pagy_get_page(vars)
        vars[:limit] ||= pagy_get_limit(vars)
      end
      pagy, response, called = yield
      # The :last_page overflow requires rerunning the method to retrieve the hits.
      if pagy.overflow? && pagy.vars[:overflow] == :last_page
        return backend.send(caller_locations(1, 1)[0].base_label, pagy_search_args, **vars, page: pagy.page)
      end

      [pagy, called&.size&.positive? ? response.send(*called) : response]
    end
  end
end
