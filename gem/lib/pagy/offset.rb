# frozen_string_literal: true

require_relative 'core/shiftable'
require_relative 'core/seriable'
require_relative 'core/rangeable'

class Pagy
  # Implements Offset Pagination
  class Offset < Pagy
    autoload :Countless, PAGY_PATH.join('offset/countless')

    include Core::Rangeable
    include Core::Seriable
    include Core::Shiftable

    DEFAULT = { page: 1 }.freeze

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

    attr_reader :offset, :from, :to

    def assign_last
      @last = [(@count.to_f / @limit).ceil, 1].max
      @last = @options[:max_pages] if @options[:max_pages] && @last > @options[:max_pages]
    end

    def assign_offset
      @offset = (@limit * (@page - 1))
    end

    # Called by false in_range?
    def assign_empty_page_variables
      @in = @from = @to = @offset = @limit = 0     # options relative to the actual page
      @previous = @last                            # @previous relative to the actual page
    end

    def offset? = true
  end
end
