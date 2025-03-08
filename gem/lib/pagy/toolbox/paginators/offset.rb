# frozen_string_literal: true

class Pagy
  module OffsetPaginator
    module_function

    # Return instance and page of results
    def paginate(context, collection, **options)
      context.instance_eval do
        request = Request.new(options[:request] || self.request, options)
        options[:page]  ||= request.resolve_page(options)
        options[:limit]   = request.resolve_limit(options)
        options[:count] ||= collection.instance_of?(Array) ? collection.size : OffsetPaginator.get_count(collection, options)
        pagy = Offset.new(**options, request:)
        [pagy, collection.instance_of?(Array) ? collection[pagy.offset, pagy.limit] : pagy.records(collection)]
      end
    end

    # Get the collection count
    def get_count(collection, options)
      arguments = [:all] if defined?(::ActiveRecord) && collection.is_a?(::ActiveRecord::Relation)
      count     = if options[:count_over] && !collection.group_values.empty?
                    # COUNT(*) OVER ()
                    sql = Arel.star.count.over(Arel::Nodes::Grouping.new([]))
                    collection.unscope(:order).pick(sql).to_i
                  else
                    collection.count(*arguments)
                  end
      count.is_a?(Hash) ? count.size : count
    end
  end
end
