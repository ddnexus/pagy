# frozen_string_literal: true

class Pagy
  # Add offset paginator
  module OffsetPaginator
    module_function

    # Return instance and page of results
    def paginate(backend, collection, **options)
      backend.instance_eval do
        options[:request] ||= Get.hash_from(request)
        options[:page]    ||= Get.page_from(params, options)
        options[:limit]     = Get.limit_from(params, options)
        options[:count]   ||= collection.instance_of?(Array) ? collection.size : OffsetPaginator.get_count(collection, options)
        pagy = Offset.new(**options)
        [pagy, collection.instance_of?(Array) ? collection[pagy.offset, pagy.limit] : pagy.records(collection)]
      end
    end

    # Get the collection count
    def get_count(collection, options)
      count = if options[:count_over] && !collection.group_values.empty?
                # COUNT(*) OVER ()
                sql = Arel.star.count.over(Arel::Nodes::Grouping.new([]))
                collection.unscope(:order).pick(sql).to_i
              else
                collection.count(*(options[:count_arguments] || [:all]))
              end
      count.is_a?(Hash) ? count.size : count
    end
  end
end
