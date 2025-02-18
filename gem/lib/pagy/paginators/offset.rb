# frozen_string_literal: true

class Pagy
  # Add offset paginator
  module Paginators
    # Return Pagy object and paginated results
    def pagy_offset(collection, **options)
      options[:request] ||= request
      options[:count]   ||= Pagy::Offset.get_count(collection, options)
      options[:page]    ||= pagy_get_page(options)
      options[:limit]     = pagy_get_limit(options)
      pagy = Offset.new(**options)
      [pagy, pagy.records(collection)]
    end
  end
end
