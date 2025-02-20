# frozen_string_literal: true

require_relative '../resources/features/shiftable'
require_relative '../resources/features/seriable'
require_relative '../resources/features/rangeable'

class Pagy
  # Implements Offset Pagination
  class Offset < Pagy
    DEFAULT = { page: 1 }.freeze

    autoload :Countless, PAGY_PATH.join('offset/countless')

    # Get the collection count
    def self.get_count(collection, options)
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

    include Rangeable
    include Seriable
    include Shiftable

    def initialize(**) # rubocop:disable Lint/MissingSuper
      assign_options(**)
      assign_and_check(limit: 1, count: 0, page: 1)
      assign_last
      assign_offset
      return unless in_range? { @page <= @last }

      @from = [@offset + 1, @count].min
      @to   = [@offset + @limit, @count].min
      @in   = [@to - @from + 1, @count].min
      assign_previous_and_next
    end

    attr_reader :offset, :count, :from, :to, :in

    def records(collection)
      collection.offset(@offset).limit(@limit)
    end

    protected

    def offset? = true

    def assign_last
      @last = [(@count.to_f / @limit).ceil, 1].max
      @last = @options[:max_pages] if @options[:max_pages] && @last > @options[:max_pages]
    end

    def assign_offset
      @offset = (@limit * (@page - 1))
    end

    # Called by false in_range?
    def assign_empty_page_variables
      @in = @from = @to = 0     # options relative to the actual page
      @previous = @last         # @previous relative to the actual page
    end
  end
end
