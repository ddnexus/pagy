# frozen_string_literal: true

class Pagy
  # Relegate internal functions. Make overriding search classes easier.
  module SearchWrapper
    module_function

    # Common search logic
    def wrap(backend, pagy_search_args, options)
      backend.instance_exec do
        options[:request] ||= Get.hash_from(request)
        options[:page]    ||= Get.page_from(params, options)
        options[:limit]   ||= Get.limit_from(params, options)
      end
      pagy, results = yield
      calling = pagy_search_args[4..]
      [pagy, calling.empty? ? results : results.send(*calling)]
    end
  end
end
