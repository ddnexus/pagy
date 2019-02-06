# See Pagy API documentation: https://ddnexus.github.io/pagy/api/pagy
# encoding: utf-8
# frozen_string_literal: true

require 'pathname'

class Pagy ; VERSION = '1.3.3'

  class OverflowError < StandardError; attr_reader :pagy; def initialize(pagy) @pagy = pagy end; end

  # Root pathname to get the path of Pagy files like templates or dictionaries
  def self.root; Pathname.new(__FILE__).dirname end

  # default vars
  VARS = { page:1, items:20, outset:0, size:[1,4,4,1], page_param: :page, params:{}, anchor:'', link_extra:'', item_path:'pagy.info.item_name', cycle: false }

  attr_reader :count, :page, :items, :vars, :pages, :last, :offset, :from, :to, :prev, :next

  # Merge and validate the options, do some simple arithmetic and set the instance variables
  def initialize(vars)
    @vars = VARS.merge(vars.delete_if{|_,v| v.nil? || v == '' })               # default vars + cleaned vars
    { count:0, items:1, outset:0, page:1 }.each do |k,min|                     # validate instance variables
      (@vars[k] && instance_variable_set(:"@#{k}", @vars[k].to_i) >= min) \
         or raise(ArgumentError, "expected :#{k} >= #{min}; got #{@vars[k].inspect}")
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
    (series = []) and size.empty? and return series
    4.times{|i| (size[i]>=0 rescue nil) or raise(ArgumentError, "expected 4 items >= 0 in :size; got #{size.inspect}")}
    [*0..size[0], *@page-size[1]..@page+size[2], *@last-size[3]+1..@last+1].sort!.each_cons(2) do |a, b|
      if    a<0 || a==b || a>@last                                        # skip out of range and duplicates
      elsif a+1 == b; series.push(a)                                      # no gap     -> no additions
      elsif a+2 == b; series.push(a, a+1)                                 # 1 page gap -> fill with missing page
      else            series.push(a, :gap)                                # n page gap -> add :gap
      end                                                                 # skip the end boundary (last+1)
    end                                                                   # shift the start boundary (0) and
    series.tap{|s| s.shift; s[s.index(@page)] = @page.to_s}               # convert the current page to String
  end

end

require 'pagy/backend'
require 'pagy/frontend'
