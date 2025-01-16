# frozen_string_literal: true

class Pagy
  Backend.module_eval do
    def pagy_wrap_search(pagy_search_args, vars)
      vars[:page]  ||= pagy_get_page(vars)
      vars[:limit] ||= pagy_get_limit(vars)
      pagy, response, called = yield
      # The :last_page overflow requires rerunning the method to retrieve the hits.
      if pagy.overflow? && pagy.vars[:overflow] == :last_page
        return send(caller_locations(1, 1)[0].base_label, pagy_search_args, **vars, page: pagy.page)
      end

      [pagy, called&.size&.positive? ? response.send(*called) : response]
    end
  end
end
