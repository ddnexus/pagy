# frozen_string_literal: true

class Pagy
  # Add offset paginator
  module Paginators
    # Return Pagy object and paginated results
    def pagy_offset(collection, **options)
      options[:request] ||= request
      options[:count]   ||= Pagy::Offset.get_count(collection, options)
      options[:page]    ||= Get.page_from(params, options)
      options[:limit]     = Get.limit_from(params, options)
      pagy = Offset.new(**options)
      [pagy, pagy.records(collection)]
    end
  end
end
