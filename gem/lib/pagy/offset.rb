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

    attr_reader :offset, :from, :to

    # Merge and validate the options, do some simple arithmetic and set the instance variables
    def initialize(**opts) # rubocop:disable Lint/MissingSuper
      assign_opts(opts)
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
      @last = @opts[:max_pages] if @opts[:max_pages] && @last > @opts[:max_pages]
    end

    def assign_offset
      @offset = (@limit * (@page - 1))
    end

    # Called by false in_range?
    def assign_empty_page_vars
      @in = @from = @to = @offset = @limit = 0     # opts relative to the actual page
      @prev = @last                                # @prev relative to the actual page
    end
  end
end
