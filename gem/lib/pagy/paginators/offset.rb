# frozen_string_literal: true

class Pagy
  # Add offset paginator
  module OffsetPaginator
    module_function

    # Return Pagy object and paginated results
    def paginate(backend, collection, **options)
      backend.instance_eval do
        options[:request] ||= Get.hash_from(request)
        options[:count]   ||= options[:array] ? collection.size : Offset.get_count(collection, options)
        options[:page]    ||= Get.page_from(params, options)
        options[:limit]     = Get.limit_from(params, options)
        pagy = Offset.new(**options)
        [pagy, options[:array] ? collection[pagy.offset, pagy.limit] : pagy.records(collection)]
      end
    end
  end
end
