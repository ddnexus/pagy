# frozen_string_literal: true

require_relative 'core/assignable'
require_relative 'core/navable'
require_relative 'core/rangeable'

class Pagy
  # Implements Offset Pagination
  class Offset < Pagy
    autoload :Countless, PAGY_PATH.join('offset/countless')

    DEFAULT = { page: 1, size: 7 }.freeze

    include Core::Assignable
    include Core::Navable
    include Core::Rangeable

    attr_reader :offset, :from, :to

    # Merge and validate the options, do some simple arithmetic and set the instance variables
    def initialize(**vars) # rubocop:disable Lint/MissingSuper
      assign_vars(vars)
      assign_and_check(limit: 1, count: 0, page: 1)
      assign_last
      assign_offset
      return unless in_range? { @page <= @last }

      @from = [@offset + 1, @count].min
      @to   = [@offset + @limit, @count].min
      @in   = [@to - @from + 1, @count].min
      assign_prev_and_next
    end

    def assign_last
      @last = [(@count.to_f / @limit).ceil, 1].max
      @last = @vars[:max_pages] if @vars[:max_pages] && @last > @vars[:max_pages]
    end

    def assign_offset
      @offset = (@limit * (@page - 1))
    end

    # Called by false in_range?
    def assign_empty_page_vars
      @in = @from = @to = @offset = @limit = 0     # vars relative to the actual page
      @prev = @last                                # @prev relative to the actual page
    end
  end
end
