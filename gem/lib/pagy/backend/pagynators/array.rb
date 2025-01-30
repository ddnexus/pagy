# frozen_string_literal: true

class Pagy
  # Paginate arrays efficiently, avoiding expensive array-wrapping and without overriding
  Backend.module_eval do
    private

    # Return Pagy object and paginated items
    def pagy_array(array, **opts)
      opts[:count] ||= array.size
      opts[:limit]   = pagy_get_limit(opts)
      opts[:page]  ||= pagy_get_page(opts)
      pagy = Offset.new(**opts)
      [pagy, array[pagy.offset, pagy.limit]]
    end
  end
end
