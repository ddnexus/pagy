# frozen_string_literal: true

class Pagy
  # Add array paginator
  module Paginators
    # Return Pagy object and paginated items
    def pagy_array(array, **options)
      options[:request] ||= request
      options[:count]   ||= array.size
      options[:page]    ||= pagy_get_page(options)
      options[:limit]     = pagy_get_limit(options)
      pagy = Offset.new(**options)
      [pagy, array[pagy.offset, pagy.limit]]
    end
  end
end
