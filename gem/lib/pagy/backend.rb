# See Pagy::Backend API documentation: https://ddnexus.github.io/pagy/docs/api/backend
# frozen_string_literal: true

class Pagy
  # Define a few generic methods to paginate a collection out of the box,
  # or any collection by overriding any of the `pagy_get_` methods in your controller.
  # See also the extras if you need specialized methods to paginate Arrays or other collections
  module Backend
    private

    # Return Pagy object and paginated results
    def pagy(collection, **vars)
      vars[:count] ||= pagy_get_count(collection, vars)
      vars[:limit] ||= pagy_get_limit(vars)
      vars[:page]  ||= pagy_get_page(vars)
      pagy = Pagy.new(**vars)
      [pagy, pagy_get_items(collection, pagy)]
    end

    # Get the count from the collection
    def pagy_get_count(collection, vars)
      count_args = vars[:count_args] || DEFAULT[:count_args]
      (count     = collection.count(*count_args)).is_a?(Hash) ? count.size : count
    end

    # Sub-method called only by #pagy: here for easy customization of fetching by overriding
    # You may need to override this method for collections without offset|limit
    def pagy_get_items(collection, pagy)
      collection.offset(pagy.offset).limit(pagy.limit)
    end

    # Override for limit extra
    def pagy_get_limit(_vars)
      DEFAULT[:limit]
    end

    # Get the page integer from the params
    # Overridable by the jsonapi extra
    def pagy_get_page(vars, force_integer: true)
      page = params[vars[:page_param] || DEFAULT[:page_param]]
      force_integer ? (page || 1).to_i : page
    end
  end
end
