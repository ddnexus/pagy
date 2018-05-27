# See Pagy::Backend API documentation: https://ddnexus.github.io/pagy/api/backend

class Pagy
  # Defines a few generic methods to paginate a ORM collection out of the box,
  # or any collection by overriding pagy_get_items in your controller

  # See also the pagy-extras gem if you need specialized methods to paginate
  # Arrays, ORM, and other TBD collections

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
