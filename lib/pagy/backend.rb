# See Pagy::Backend API documentation: https://ddnexus.github.io/pagy/api/backend

class Pagy
  # Defines a few generic methods to paginate an ORM collection out of the box,
  # or any collection by overriding pagy_get_items and/or pagy_get_vars in your controller

  # See also the extras if you need specialized methods to paginate Arrays or other collections

  module Backend ; private         # the whole module is private so no problem with including it in a controller

    # Return Pagy object and items
    def pagy(collection, vars={})
      pagy = Pagy.new(pagy_get_vars(collection, vars))
      return pagy, pagy_get_items(collection, pagy)
    end

    # Sub-method called only by #pagy: here for easy customization of variables by overriding
    def pagy_get_vars(collection, vars)
      count = collection.count(:all)
      count = count.count if count.respond_to?(:count) # e.g. AR .group returns an OrderdHash that responds to #count
      # return the merged variables to initialize the pagy object
      { count: count, page: params[vars[:page_param] || VARS[:page_param]] }.merge!(vars)
    end

    # Sub-method called only by #pagy: here for easy customization of record-extraction by overriding
    def pagy_get_items(collection, pagy)
      # This should work with ActiveRecord, Sequel, Mongoid...
      collection.offset(pagy.offset).limit(pagy.items)
    end

  end
end
