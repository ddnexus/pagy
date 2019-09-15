# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/array
# encoding: utf-8
# frozen_string_literal: true

class Pagy
  # Add specialized backend methods to paginate active record collections with group by
  module Backend ; private

    # Return Pagy object and items
    def pagy_aggregated(collection, vars={})
      pagy = Pagy.new(pagy_aggregated_get_vars(collection, vars))
      return pagy, pagy_get_items(collection, pagy)
    end

    # Sub-method called only by #pagy_array: here for easy customization of variables by overriding
    def pagy_aggregated_get_vars(collection, vars)
      sql = Arel.sql("COUNT(*) OVER () as count_all")
      vars[:count] ||= collection.unscope(:order).pick(sql)
      vars[:page]  ||= params[ vars[:page_param] || VARS[:page_param] ]
      vars
    end

  end
end
