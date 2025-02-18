# frozen_string_literal: true

class Pagy
  # Add keynav paginator
  module Paginators
    # Return Pagy::Keyset object and paginated records
    def pagy_keyset(set, **options)
      options[:request] ||= request
      options[:page]    ||= Get.page_from(params, options, force_integer: false) # allow nil
      options[:limit]     = Get.limit_from(params, options)
      pagy = Keyset.new(set, **options)
      [pagy, pagy.records]
    end
  end
end
