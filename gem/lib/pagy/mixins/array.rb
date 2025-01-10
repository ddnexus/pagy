# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/array
# frozen_string_literal: true

require_relative '../offset'

class Pagy
  # Paginate arrays efficiently, avoiding expensive array-wrapping and without overriding
  Backend.class_eval do
    private

    # Return Pagy object and paginated items
    def pagy_array(array, **vars)
      vars[:count] ||= array.size
      vars[:limit] ||= pagy_get_limit(vars)
      vars[:page]  ||= pagy_get_page(vars)
      pagy = Offset.new(**vars)
      [pagy, array[pagy.offset, pagy.limit]]
    end
  end
end
