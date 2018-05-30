# See the Pagy Extras documentation: https://ddnexus.github.io/pagy/extras

class Pagy
  # Add specialized backend methods to paginate array collections
  module Backend ; private

    # return pagy object and items
    def pagy_array(array, vars={})
      pagy = Pagy.new(pagy_array_get_vars(array, vars))
      return pagy, array[pagy.offset, pagy.items]
    end

    def pagy_array_get_vars(array, vars)
      # return the merged variables to initialize the pagy object
      { count: array.count,
        page:  params[vars[:page_param]||VARS[:page_param]] }.merge!(vars)
    end

  end
end
