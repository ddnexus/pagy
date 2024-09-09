# See Pagy API documentation: https://ddnexus.github.io/pagy/docs/api/pagy
# frozen_string_literal: true

require 'pathname'
require_relative 'pagy/shared_methods'

# Top superclass: it should define only what's common to all the subclasses
class Pagy
  VERSION = '9.0.9'

  # Core default: constant for easy access, but mutable for customizable defaults
  DEFAULT = { count_args: [:all], # rubocop:disable Style/MutableConstant
              ends:       true,
              limit:      20,
              outset:     0,
              page:       1,
              page_param: :page,
              size:       7 }  # AR friendly

  # Gem root pathname to get the path of Pagy files stylesheets, javascripts, apps, locales, etc.
  def self.root
    @root ||= Pathname.new(__dir__).parent.freeze
  end

  include SharedMethods

  attr_reader :count, :from, :in, :last, :next, :offset, :prev, :to
  alias pages last

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

  # Label for the current page. Allow the customization of the output (overridden by the calendar extra)
  def label = @page.to_s

  # Label for any page. Allow the customization of the output (overridden by the calendar extra)
  def label_for(page) = page.to_s

  # Return the array of page numbers and :gap e.g. [1, :gap, 8, "9", 10, :gap, 36]
  def series(size: @vars[:size], **_)
    raise VariableError.new(self, :size, 'to be an Integer >= 0', size) \
    unless size.is_a?(Integer) && size >= 0
    return [] if size.zero?

    [].tap do |series|
      if size >= @last
        series.push(*1..@last)
      else
        left  = ((size - 1) / 2.0).floor             # left half might be 1 page shorter for even size
        start = if @page <= left                     # beginning pages
                  1
                elsif @page > (@last - size + left)  # end pages
                  @last - size + 1
                else                                 # intermediate pages
                  @page - left
                end
        series.push(*start...start + size)
        # Set first and last pages plus gaps when needed, respecting the size
        if vars[:ends] && size >= 7
          series[0]  = 1     unless series[0]  == 1
          series[1]  = :gap  unless series[1]  == 2
          series[-2] = :gap  unless series[-2] == @last - 1
          series[-1] = @last unless series[-1] == @last
        end
      end
      series[series.index(@page)] = @page.to_s
    end
  end
end

require_relative 'pagy/backend'
require_relative 'pagy/frontend'
require_relative 'pagy/exceptions'
