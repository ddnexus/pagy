require 'pathname'
require 'ostruct'

# This class takes a few integers (such as collection-count, page-number,
# items-per-page-limit, etc.), does some simple aritmetic and creates a very
# small object (~3k) with all is needed for pagination and navigation.
# Notice that it doesn't actually do any pagination, nor navigation... that is
# done with a few helpers in the Pagy::Backend and Pagy::Frontend modules.

class Pagy ; VERSION = '0.4.2'

  autoload :Backend,  'pagy/backend'
  autoload :Frontend, 'pagy/frontend'

  class OutOfRangeError < StandardError; end

  # root pathname to get the path of pagy files like templates or locales
  def self.root; Pathname.new(__FILE__).dirname end

  # default options
  # limit:         max items per page: it gets adjusted for the last page,
  #                so it will pull the right items if the collection was pre-limit(ed)
  # offset:        the initial offset of the whole collection before pagination
  #                set it only if the collection was pre-offset(ted): it gets added to the final offset
  # initial/final: max pages to show from the first/last page
  # before/after:  max pages before/after the current page
  Opts = OpenStruct.new(limit:20, offset:0, initial:1, before:4, after:4, final:1)

  attr_reader :count, :page, :limit, :opts, :pages, :last, :offset, :from, :to, :prev, :next, :series

  # merge and validate the options, do some simple aritmetic and set the instance variables
  def initialize(opts)
    @opts        = Opts.to_h.merge!(opts)                                 # global opts + instance opts (bang faster)
    @opts[:page] = (@opts[:page]||1).to_i                                 # set page to 1 if nil
    [:count, :limit, :offset, :initial, :before, :page, :after, :final].each do |k|
      @opts[k] >= 0 rescue nil || raise(ArgumentError, "expected #{k} >= 0; got #{@opts[k].inspect}")
      instance_variable_set(:"@#{k}", @opts.delete(k))                    # set all the metrics variables
    end
    @pages   = @last = [(@count.to_f / @limit).ceil, 1].max               # cardinal and ordinal meanings
    (1..@last).cover?(@page) || raise(OutOfRangeError, "expected :page in 1..#{@last}; got #{@page.inspect}")
    @offset += @limit * (@page - 1)                                       # initial offset + offset for pagination
    @limit   = @count % @limit if @page == @last                          # adjust limit for last page (for pre-limit(ed) collection)
    @from    = @count.zero? ? 0 : @offset+1                               # page begins from item
    @to      = @offset + @limit                                           # page ends to item
    @prev    = (@page-1 unless @page == 1)                                # nil if no prev page
    @next    = (@page+1 unless @page == @last)                            # nil if no next page
    @series  = []                                                         # e.g. [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
    all      = (0..@last+1)                                               # page range with boundaries
    around   = ([@page-@before, 1].max .. [@page+@after, @last].min).to_a # before..after pages
    row      = (all.first(@initial+1) | around | all.last(@final+1)).sort # row of pages with boundaries
    row.each_cons(2) do |a, b|                                            # loop in consecutive pairs
      if    a+1 == b; @series.push(a)                                     # no gap     -> no additions
      elsif a+2 == b; @series.push(a, a+1)                                # 1 page gap -> fill with missing page
      else            @series.push(a, :gap)                               # n page gap -> add :gap
      end                                                                 # skip the end-boundary (last+1)
    end
    @series.shift                                                         # remove the start-boundary (0)
    @series[@series.index(@page)] = @page.to_s                            # convert the current page to String
  end

end
