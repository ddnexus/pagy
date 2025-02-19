# frozen_string_literal: true

class Pagy
  # Add array paginator
  module Paginators
    protected

    # Return Pagy object and paginated items
    def pagy_array(array, **options)
      options[:request] ||= Get.hash_from(request)
      options[:count]   ||= array.size
      options[:page]    ||= Get.page_from(params, options)
      options[:limit]     = Get.limit_from(params, options)
      pagy = Offset.new(**options)
      [pagy, array[pagy.offset, pagy.limit]]
    end
  end
end
