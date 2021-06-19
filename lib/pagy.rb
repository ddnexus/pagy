# See Pagy API documentation: https://ddnexus.github.io/pagy/api/pagy
# frozen_string_literal: true

require 'pathname'

# main class
class Pagy
  VERSION = '4.9.0'

  # Root pathname to get the path of Pagy files like templates or dictionaries
  def self.root
    @root ||= Pathname.new(__dir__).freeze
  end

  # default vars
  VARS = { page: 1, items: 20, outset: 0, size: [1, 4, 4, 1], page_param: :page,              # rubocop:disable Style/MutableConstant
           params: {}, fragment: '', link_extra: '', i18n_key: 'pagy.item_name', cycle: false }

  attr_reader :count, :page, :items, :vars, :pages, :last, :offset, :from, :to, :prev, :next

  INSTANCE_VARS_MIN = { count: 0, items: 1, page: 1, outset: 0 }.freeze

  # Merge and validate the options, do some simple arithmetic and set the instance variables
  def initialize(vars)
    @vars = VARS.merge( vars.delete_if{|k,v| VARS.key?(k) && (v.nil? || v == '') } )
    @vars[:fragment] = Pagy.deprecated_var(:anchor, @vars[:anchor], :fragment, @vars[:fragment]) if @vars[:anchor]

    INSTANCE_VARS_MIN.each do |name,min|
      raise VariableError.new(self), "expected :#{name} >= #{min}; got #{@vars[name].inspect}" \
            unless @vars[name] && instance_variable_set(:"@#{name}", @vars[name].to_i) >= min
    end
    @pages = @last = [(@count.to_f / @items).ceil, 1].max
    raise OverflowError.new(self), "expected :page in 1..#{@last}; got #{@page.inspect}" \
          if @page > @last

    @offset = @items * (@page - 1) + @outset
    @items  = @count - ((@pages - 1) * @items) if @page == @last && @count.positive?
    @from   = @count.zero? ? 0 : @offset + 1 - @outset
    @to     = @count.zero? ? 0 : @offset + @items - @outset
    @prev   = (@page - 1 unless @page == 1)
    @next   = @page == @last ? (1 if @vars[:cycle]) : @page + 1
  end

  # Return the array of page numbers and :gap items e.g. [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
  def series(size=@vars[:size])
    return [] if size.empty?
    raise VariableError.new(self), "expected 4 items >= 0 in :size; got #{size.inspect}" \
          unless size.size == 4 && size.all?{ |num| !num.negative? rescue false }  # rubocop:disable Style/RescueModifier
    # This algorithm is up to ~5x faster and ~2.3x lighter than the previous one (pagy < 4.3)
    left_gap_start  =     1 + size[0]
    left_gap_end    = @page - size[1] - 1
    right_gap_start = @page + size[2] + 1
    right_gap_end   = @last - size[3]
    left_gap_end    = right_gap_end  if left_gap_end   > right_gap_end
    right_gap_start = left_gap_start if left_gap_start > right_gap_start
    series = []
    start  = 1
    if (left_gap_end - left_gap_start).positive?
      series.push(*start..(left_gap_start - 1), :gap)
      start = left_gap_end + 1
    end
    if (right_gap_end - right_gap_start).positive?
      series.push(*start..(right_gap_start - 1), :gap)
      start = right_gap_end + 1
    end
    series.push(*start..@last)
    series[series.index(@page)] = @page.to_s
    series
  end

end

require 'pagy/deprecation'
require 'pagy/backend'
require 'pagy/frontend'
require 'pagy/exceptions'
