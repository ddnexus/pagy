# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/array
# frozen_string_literal: true

class Pagy # :nodoc:
  # Paginate arrays efficiently, avoiding expensive array-wrapping and without overriding
  module ArrayExtra
    private

    # Return Pagy object and items
    def pagy_array(array, vars = {})
      pagy = Pagy.new(pagy_array_get_vars(array, vars))
      [pagy, array[pagy.offset, pagy.items]]
    end

    # Sub-method called only by #pagy_array: here for easy customization of variables by overriding
    def pagy_array_get_vars(array, vars)
      pagy_set_items_from_params(vars) if defined?(ItemsExtra)
      vars[:count] ||= array.size
      vars[:page]  ||= params[vars[:page_param] || DEFAULT[:page_param]]
      vars
    end
  end
  Backend.prepend ArrayExtra
end
