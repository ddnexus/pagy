# See Pagy::Backend API documentation: https://ddnexus.github.io/pagy/docs/api/backend
# frozen_string_literal: true

require_relative 'loaders/backend'

class Pagy
  # Define a few generic methods to paginate a collection out of the box,
  # or any collection by overriding any of the `pagy_*` methods in your controller.
  # See also the extras if you need specialized methods to paginate Arrays or other collections
  module Backend
    private

    # Sub-method called only by #pagy: here for easy customization of fetching by overriding
    # You may need to override this method for collections without offset|limit
    def pagy_get_items(collection, pagy)
      collection.offset(pagy.offset).limit(pagy.limit)
    end

    # Get the limit from request, vars or DEFAULT
    def pagy_get_limit(vars)
      if vars.key?(:limit_requestable) ? vars[:limit_requestable] : DEFAULT[:limit_requestable]
        limit = pagy_requested_limit(vars) || DEFAULT[:limit]
        [limit.to_i, (vars[:limit_max] ||= DEFAULT[:limit_max] || 100)].compact.min
      else
        DEFAULT[:limit]
      end
    end

    # Get the limit from the request
    # Overridable by the jsonapi extra
    def pagy_requested_limit(vars)
      params[vars[:limit_sym] || DEFAULT[:limit_sym]]
    end

    # Get the page integer from the params
    # Overridable by the jsonapi extra
    def pagy_get_page(vars, force_integer: true)
      page = params[vars[:page_sym] || DEFAULT[:page_sym]]
      force_integer ? (page || 1).to_i : page
    end

    include Loaders::Backend
  end
end
