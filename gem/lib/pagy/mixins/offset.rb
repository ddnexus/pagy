# See Pagy::Offset::Backend API documentation: https://ddnexus.github.io/pagy/docs/api/backend
# frozen_string_literal: true

require_relative '../offset'

class Pagy
  module OffsetMixin
    # Define a few generic methods to paginate a collection out of the box,
    # or any collection by overriding any of the `pagy_*` methods in your controller.
    # See also the extras if you need specialized methods to paginate Arrays or other collections
    module BackendAddOn
      private

      # Return Pagy object and paginated results
      def pagy_offset(collection, **vars)
        vars[:count] ||= pagy_get_count(collection, vars)
        vars[:limit] ||= pagy_get_limit(vars)
        vars[:page]  ||= pagy_get_page(vars)
        pagy = Pagy::Offset.new(**vars)
        [pagy, pagy_get_items(collection, pagy)]
      end

      # Get the count from the collection
      def pagy_get_count(collection, vars)
        count_args = vars[:count_args] || DEFAULT[:count_args]
        (count     = collection.count(*count_args)).is_a?(Hash) ? count.size : count
      end
    end
    Backend.prepend BackendAddOn
  end
end
