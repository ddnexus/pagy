# See Pagy API documentation: https://ddnexus.github.io/pagy/api/pagy
# encoding: utf-8
# frozen_string_literal: true

require 'pathname'

class Pagy ; VERSION = '3.13.0'

  # Root pathname to get the path of Pagy files like templates or dictionaries
  def self.root; @root ||= Pathname.new(__FILE__).dirname.freeze end

  # default vars
  VARS = { page:1, items:20, outset:0, size:[1,4,4,1], page_param: :page, params:{}, anchor:'', link_extra:'', i18n_key:'pagy.item_name', cycle:false }

  attr_reader :count, :page, :items, :vars, :pages, :last, :offset, :from, :to, :prev, :next

  # Merge and validate the options, do some simple arithmetic and set the instance variables
  def initialize(vars)
    @vars = VARS.merge(vars.delete_if{|_,v| v.nil? || v == '' })               # default vars + cleaned vars
    { count:0, items:1, outset:0, page:1 }.each do |k,min|                     # validate instance variables
      (@vars[k] && instance_variable_set(:"@#{k}", @vars[k].to_i) >= min) \
         or raise(VariableError.new(self), "expected :#{k} >= #{min}; got #{@vars[k].inspect}")
    end
    @pages = @last = [(@count.to_f / @items).ceil, 1].max                      # cardinal and ordinal meanings
    @page <= @last or raise(OverflowError.new(self), "expected :page in 1..#{@last}; got #{@page.inspect}")
    @offset = @items * (@page - 1) + @outset                                   # pagination offset + outset (initial offset)
    @items  = @count - ((@pages-1) * @items) if @page == @last && @count > 0   # adjust items for last non-empty page
    @from   = @count == 0 ? 0 : @offset+1 - @outset                            # page begins from item
    @to     = @count == 0 ? 0 : @offset + @items - @outset                     # page ends to item
    @prev   = (@page-1 unless @page == 1)                                      # nil if no prev page
    @next   = @page == @last ? (1 if @vars[:cycle]) : @page+1                  # nil if no next page, 1 if :cycle
  end

  # Return the array of page numbers and :gap items e.g. [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
def series(size=@vars[:size])
  return [] if size.empty?
  raise VariableError.new(self), "expected 4 items >= 0 in :size; got #{size.inspect}" \
          unless size.size == 4 && size.all?{ |num| num >= 0 rescue false }
  # This algorithm (backported from pagy 4.3) is up to ~5x faster and ~2.3x lighter than the previous one
  left_gap_start  =     1 + size[0]
  left_gap_end    = @page - size[1] - 1
  right_gap_start = @page + size[2] + 1
  right_gap_end   = @last - size[3]
  left_gap_end    = right_gap_end  if left_gap_end   > right_gap_end
  right_gap_start = left_gap_start if left_gap_start > right_gap_start
  series = []
  start  = 1
  if (left_gap_end - left_gap_start) > 0
    series.push(*start..(left_gap_start - 1), :gap)
    start = left_gap_end + 1
  end
  if (right_gap_end - right_gap_start) > 0
    series.push(*start..(right_gap_start - 1), :gap)
    start = right_gap_end + 1
  end
  series.push(*start..@last)
  series[series.index(@page)] = @page.to_s
  series
end

end

require 'pagy/backend'
require 'pagy/frontend'
require 'pagy/exceptions'
