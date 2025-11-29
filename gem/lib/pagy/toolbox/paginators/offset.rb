# frozen_string_literal: true

class Pagy
  module OffsetPaginator
    module_function

    # Return the Pagy::Offset instance and results
    def paginate(collection, options)
      options[:page]  ||= options[:request].resolve_page
      options[:limit]   = options[:request].resolve_limit
      options[:count] ||= collection.instance_of?(Array) ? collection.size : OffsetPaginator.get_count(collection, options)
      pagy = Offset.new(**options)
      [pagy, collection.instance_of?(Array) ? collection[pagy.offset, pagy.limit] : pagy.records(collection)]
    end

    # Get the collection count
    def get_count(collection, options)
      return collection.count unless defined?(::ActiveRecord) && collection.is_a?(::ActiveRecord::Relation)

      count = if options[:count_over] && !collection.group_values.empty?
                # COUNT(*) OVER ()
                sql = Arel.star.count.over(Arel::Nodes::Grouping.new([]))
                collection.unscope(:order).then do |unordered|
                  options[:async_count] ? unordered.async_pick(sql).value : unordered.pick(sql)
                end.to_i
              else
                start_time = Time.now.to_f
                Rails.logger.info "[Pagy::OffsetPaginator] Starting count query at #{start_time} (async: #{options[:async_count]})"
                count_result = options[:async_count] ? collection.async_count(:all).value : collection.count(:all)
                end_time = Time.now.to_f
                duration = ((end_time - start_time) * 1000).round(2)
                Rails.logger.info "[Pagy::OffsetPaginator] Completed count query at #{end_time} (duration: #{duration}ms)"
                count_result
              end
      count.is_a?(Hash) ? count.size : count
    end
  end
end
