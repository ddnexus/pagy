# frozen_string_literal: true

class Pagy
  # Model extension
  module Search
    def pagy_search(term = nil, **options, &block)
      [self, term, options, block].tap do |args|
        args.define_singleton_method(:method_missing) { |*a| args += a }
      end
    end
  end

  Backend.module_eval do
    def pagy_wrap_search(pagy_search_args, vars)
      vars[:page]  ||= pagy_get_page(vars)
      vars[:limit] ||= pagy_get_limit(vars)
      pagy, response, called = yield
      # with :last_page overflow we need to re-run the method in order to get the hits
      if pagy.overflow? && pagy.vars[:overflow] == :last_page
        return send(caller_locations(1, 1)[0].base_label, pagy_search_args, **vars, page: pagy.page)
      end

      [pagy, called&.size&.positive? ? response.send(*called) : response]
    end
  end
end
