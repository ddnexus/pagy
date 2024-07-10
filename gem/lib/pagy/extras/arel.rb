# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/arel
# frozen_string_literal: true

class Pagy # :nodoc:
  # Better performance of grouped ActiveRecord collections
  module ArelExtra
    private

    # Return Pagy object and paginated collection/results
    def pagy_arel(collection, vars = {})
      pagy = Pagy.new(pagy_arel_get_vars(collection, vars))
      [pagy, pagy_get_records(collection, pagy)]
    end

    # Sub-method called only by #pagy_arel: here for easy customization of variables by overriding
    def pagy_arel_get_vars(collection, vars)
      vars[:count] ||= pagy_arel_count(collection)
      pagy_get_vars(collection, vars)
    end

    # Count using Arel when grouping
    def pagy_arel_count(collection)
      if collection.group_values.empty?
        # COUNT(*)
        collection.count(:all)
      else
        # COUNT(*) OVER ()
        sql = Arel.star.count.over(Arel::Nodes::Grouping.new([]))
        collection.unscope(:order).limit(1).pluck(sql).first.to_i
      end
    end
  end
  Backend.prepend ArelExtra
end
