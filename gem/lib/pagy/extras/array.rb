# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/array
# frozen_string_literal: true

class Pagy # :nodoc:
  # Paginate arrays efficiently, avoiding expensive array-wrapping and without overriding
  module ArrayExtra
    private

    # Return Pagy object and paginated items
    def pagy_array(array, **vars)
      vars[:limit] ||= pagy_get_limit(vars)
      vars[:page]  ||= pagy_get_page(vars)
      vars[:count] ||= array.size
      pagy = Pagy.new(**vars)
      [pagy, array[pagy.offset, pagy.limit]]
    end
  end
  Backend.prepend ArrayExtra
end
