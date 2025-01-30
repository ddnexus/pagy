# See Pagy::Offset::Backend API documentation: https://ddnexus.github.io/pagy/docs/api/backend
# frozen_string_literal: true

class Pagy
  # Basic offset mixin
  Backend.module_eval do
    private

    # Return Pagy object and paginated results
    def pagy_offset(collection, **opts)
      opts[:count] ||= pagy_get_count(collection, opts)
      opts[:page]  ||= pagy_get_page(opts)
      opts[:limit]   = pagy_get_limit(opts)
      pagy = Offset.new(**opts)
      [pagy, pagy_get_items(collection, pagy)]
    end

    # Get the count from the collection
    def pagy_get_count(collection, opts)
      count_args = opts[:count_args] || [:all]
      (count     = collection.count(*count_args)).is_a?(Hash) ? count.size : count
    end

    # You may need to override this method for collections without offset|limit
    def pagy_get_items(collection, pagy)
      collection.offset(pagy.offset).limit(pagy.limit)
    end
  end
end
