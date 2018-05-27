# See the Pagy Extras documentation: https://ddnexus.github.io/pagy/extras

class Pagy
  # Add specialized backend methods to paginate array collections
  module Backend ; private

    # return pagy object and items
    def pagy_array(array, vars=nil)
      pagy = Pagy.new(vars ? pagy_array_get_vars(array).merge!(vars) : pagy_array_get_vars(array))   # conditional merge is faster and saves memory
      return pagy, array[pagy.offset, pagy.items]
    end

    # sub-method called only by #pagy_array: here for easy customization of variables by overriding
    def pagy_array_get_vars(array)
      # return the variables to initialize the pagy object
      { count: array.count, page: params[:page] }
    end

  end
end
