# See Pagy::Backend API documentation: https://ddnexus.github.io/pagy/api/backend

class Pagy
  module Backend ; private         # the whole module is private so no problem with including it in a controller

    # return pagy object and items
    def pagy(collection, vars=nil)
      pagy = Pagy.new(vars ? pagy_get_vars(collection).merge!(vars) : pagy_get_vars(collection))   # conditional merge is faster and saves memory
      return pagy, pagy_get_items(collection, pagy)
    end

    # sub-method called only by #pagy: here for easy customization of variables by overriding
    def pagy_get_vars(collection)
      # return the variables to initialize the pagy object
      { count: collection.count, page: params[:page] }
    end

    # sub-method called only by #pagy: here for easy customization of record-extraction by overriding
    def pagy_get_items(collection, pagy)
      # this should work with ActiveRecord, Sequel, Mongoid...
      collection.offset(pagy.offset).limit(pagy.items)
    end

  end
end
