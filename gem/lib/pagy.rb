# See Pagy API documentation: https://ddnexus.github.io/pagy/docs/api/pagy
# frozen_string_literal: true

require 'pathname'
require_relative 'pagy/shared_methods'

# Top superclass: it should define only what's common to all the subclasses
class Pagy
  VERSION = '9.3.3'

  # Core default: constant for easy access, but mutable for customizable defaults
  DEFAULT = { count_args: [:all],  # AR friendly # rubocop:disable Style/MutableConstant
              ends:       true,
              limit:      20,
              outset:     0,
              page:       1,
              page_sym:   :page,
              size:       7 }

  # Gem root pathname to get the path of Pagy files stylesheets, javascripts, apps, locales, etc.
  def self.root
    @root ||= Pathname.new(__dir__).parent.freeze
  end

  include SharedMethods
  include SharedUIMethods

  attr_reader :count, :from, :in, :next, :offset, :to

  # Merge and validate the options, do some simple arithmetic and set the instance variables
  def initialize(**vars)
    assign_vars(DEFAULT, vars)
    assign_and_check(count: 0, page: 1, outset: 0)
    assign_limit
    assign_offset
    assign_last
    check_overflow
    @from = [@offset - @outset + 1, @count].min
    @to   = [@offset - @outset + @limit, @count].min
    @in   = [@to - @from + 1, @count].min
    assign_prev_and_next
  end

  # Setup @last (overridden by the gearbox extra)
  def assign_last
    @last = [(@count.to_f / @limit).ceil, 1].max
    @last = @vars[:max_pages] if @vars[:max_pages] && @last > vars[:max_pages]
  end

  # Assign @offset (overridden by the gearbox extra)
  def assign_offset
    @offset = (@limit * (@page - 1)) + @outset  # may be already set from gear_box
  end

  # Assign @prev and @next
  def assign_prev_and_next
    @prev = (@page - 1 unless @page == 1)
    @next = @page == @last ? (1 if @vars[:cycle]) : @page + 1
  end

  # Checks the @page <= @last
  def check_overflow
    raise OverflowError.new(self, :page, "in 1..#{@last}", @page) if @page > @last
  end
end

require_relative 'pagy/backend'
require_relative 'pagy/frontend'
require_relative 'pagy/exceptions'
