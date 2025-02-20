# frozen_string_literal: true

class Pagy
  # Add array paginator
  module ArrayPaginator
    module_function

    # Return Pagy object and paginated items
    def paginate(backend, array, **options)
      backend.instance_eval do
        options[:count] ||= array.size
        options[:page]  ||= Get.page_from(params, options)
        options[:limit] = Get.limit_from(params, options)
        pagy            = Offset.new(**options)
        [pagy, array[pagy.offset, pagy.limit]]
      end
    end
  end
end
