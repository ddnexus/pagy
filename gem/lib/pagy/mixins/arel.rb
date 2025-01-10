# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/arel
# frozen_string_literal: true

require_relative 'offset'   # require the offset mixin

class Pagy
  Backend.class_eval do
    private

    # Return Pagy object and paginated collection/results
    def pagy_arel(collection, **vars)
      vars[:count] ||= pagy_arel_count(collection)
      pagy_offset(collection, **vars)
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
end
