# frozen_string_literal: true

class Pagy
  # Add offset paginator
  Backend.module_eval do
    private

    # Return Pagy object and paginated results
    def pagy_offset(collection, **options)
      options[:count] ||= pagy_get_count(collection, options)
      options[:page]  ||= pagy_get_page(options)
      options[:limit]   = pagy_get_limit(options)
      pagy = Offset.new(**options)
      [pagy, pagy_get_items(collection, pagy)]
    end

    # Get the collection count
    def pagy_get_count(collection, options)
      count_args = options[:count_args] || [:all]
      count      = if options[:count_over] && !collection.group_values.empty?
                     # COUNT(*) OVER ()
                     sql = Arel.star.count.over(Arel::Nodes::Grouping.new([]))
                     collection.unscope(:order).pick(sql).to_i
                   else
                     collection.count(*count_args)
                   end
      count.is_a?(Hash) ? count.size : count
    end

    # Get the items for the page
    def pagy_get_items(collection, pagy)
      collection.offset(pagy.offset).limit(pagy.limit)
    end
  end
end
