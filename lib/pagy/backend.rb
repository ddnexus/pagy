# See Pagy::Backend API documentation: https://ddnexus.github.io/pagy/docs/api/backend
# frozen_string_literal: true

class Pagy
  # Define a few generic methods to paginate an ORM collection out of the box,
  # or any collection by overriding pagy_get_items and/or pagy_get_vars in your controller
  # See also the extras if you need specialized methods to paginate Arrays or other collections
  module Backend
    private

    # Return Pagy object and paginated items/results
    def pagy(collection, vars = {})
      pagy = Pagy.new(pagy_get_vars(collection, vars))
      [pagy, pagy_get_items(collection, pagy)]
    end

    # Sub-method called only by #pagy: here for easy customization of variables by overriding
    # You may need to override the count call for non AR collections
    def pagy_get_vars(collection, vars)
      pagy_set_items_from_params(vars) if defined?(ItemsExtra)
      vars[:count] ||= (count = collection.count(:all)).is_a?(Hash) ? count.size : count
      vars[:page]  ||= params[vars[:page_param] || DEFAULT[:page_param]]
      vars
    end

    # Sub-method called only by #pagy: here for easy customization of record-extraction by overriding
    # You may need to override this method for collections without offset|limit
    def pagy_get_items(collection, pagy)
      collection.offset(pagy.offset).limit(pagy.items)
    end
  end
end
