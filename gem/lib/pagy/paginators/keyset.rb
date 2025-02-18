# frozen_string_literal: true

class Pagy
  # Add keynav paginator
  module Paginators
    # Return Pagy::Keyset object and paginated records
    def pagy_keyset(set, **options)
      options[:request] ||= request
      options[:page]    ||= pagy_get_page(options, force_integer: false) # allow nil
      options[:limit]     = pagy_get_limit(options)
      pagy = Keyset.new(set, **options)
      [pagy, pagy.records]
    end
  end
end
