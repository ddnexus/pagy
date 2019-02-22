# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/array
# encoding: utf-8
# frozen_string_literal: true

class Pagy
  # Add specialized backend methods to paginate array collections
  module Backend ; private

    # Return Pagy object and items
    def pagy_array(array, vars={})
      pagy = Pagy.new(pagy_array_get_vars(array, vars))
      return pagy, array[pagy.offset, pagy.items]
    end

    # Sub-method called only by #pagy_array: here for easy customization of variables by overriding
    def pagy_array_get_vars(array, vars)
      vars[:count] ||= array.size
      vars[:page]  ||= params[ vars[:page_param] || VARS[:page_param] ]
      vars
    end

  end
end
