# See Pagy::Backend API documentation: https://ddnexus.github.io/pagy/api/backend

class Pagy
  # Defines a few generic methods to paginate a ORM collection out of the box,
  # or any collection by overriding pagy_get_items in your controller

  # See also the extras if you need specialized methods to paginate
  # Arrays, ORM, and other TBD collections

  module Backend ; private         # the whole module is private so no problem with including it in a controller

    # return pagy object and items
    def pagy(collection, vars={})
      pagy = Pagy.new(pagy_get_vars(collection, vars))
      return pagy, pagy_get_items(collection, pagy)
    end

    # sub-method called only by #pagy: here for easy customization of variables by overriding
    def pagy_get_vars(collection, vars)
      # return the merged variables to initialize the pagy object
      { count: collection.count(:all),
        page:  params[vars[:page_param]||VARS[:page_param]] }.merge!(vars)
    end

    # sub-method called only by #pagy: here for easy customization of record-extraction by overriding
    def pagy_get_items(collection, pagy)
      # this should work with ActiveRecord, Sequel, Mongoid...
      collection.offset(pagy.offset).limit(pagy.items)
    end

  end
end
