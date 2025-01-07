# See Pagy::Backend API documentation: https://ddnexus.github.io/pagy/docs/api/backend
# frozen_string_literal: true

require_relative 'url_helpers'

class Pagy
  # Define a few generic methods to paginate a collection out of the box,
  # or any collection by overriding any of the `pagy_*` methods in your controller.
  # See also the extras if you need specialized methods to paginate Arrays or other collections
  module Backend
    include Pagy::Autoloading
    private

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
      page = params[vars[:page_sym] || DEFAULT[:page_sym]]
      force_integer ? (page || 1).to_i : page
    end
  end
end
