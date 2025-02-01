# frozen_string_literal: true

class Pagy
  # Paginate arrays efficiently
  Backend.module_eval do
    private

    # Return Pagy object and paginated items
    def pagy_array(array, **options)
      options[:count] ||= array.size
      options[:limit]   = pagy_get_limit(options)
      options[:page]  ||= pagy_get_page(options)
      pagy = Offset.new(**options)
      [pagy, array[pagy.offset, pagy.limit]]
    end
  end
end
