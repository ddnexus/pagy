# See Pagy::Offset::Backend API documentation: https://ddnexus.github.io/pagy/docs/api/backend
# frozen_string_literal: true

class Pagy
  # Basic offset mixin
  Backend.module_eval do
    private

    # Return Pagy object and paginated results
    def pagy_offset(collection, **vars)
      vars[:count] ||= pagy_get_count(collection, vars)
      vars[:page]  ||= pagy_get_page(vars)
      vars[:limit]   = pagy_get_limit(vars)
      pagy = Offset.new(**vars)
      [pagy, pagy_get_items(collection, pagy)]
    end

    # Get the count from the collection
    def pagy_get_count(collection, vars)
      count_args = vars[:count_args] || DEFAULT[:count_args]
      (count     = collection.count(*count_args)).is_a?(Hash) ? count.size : count
    end

    # You may need to override this method for collections without offset|limit
    def pagy_get_items(collection, pagy)
      collection.offset(pagy.offset).limit(pagy.limit)
    end
  end
end
