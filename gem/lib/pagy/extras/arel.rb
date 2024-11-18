# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/arel
# frozen_string_literal: true
# You can override any of the `pagy_*` methods in your controller.

class Pagy # :nodoc:
  # Better performance of grouped ActiveRecord collections
  module ArelExtra
    private

    # Return Pagy object and paginated collection/results
    def pagy_arel(collection, **vars)
      vars[:count] ||= pagy_arel_count(collection)
      pagy(collection, **vars)
    end

    # Count using Arel when grouping
    def pagy_arel_count(collection)
      if collection.group_values.empty?
        # COUNT(*)
        collection.count(:all)
      else
        # COUNT(*) OVER ()
        sql = Arel.star.count.over(Arel::Nodes::Grouping.new([]))
        collection.unscope(:order).pick(sql).to_i
      end
    end
  end
  Backend.prepend ArelExtra
end
