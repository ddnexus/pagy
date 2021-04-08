# See Pagy API documentation: https://ddnexus.github.io/pagy/api/pagy
# frozen_string_literal: true

require 'pathname'

# main class
class Pagy
  VERSION = '4.1.0'

  # Root pathname to get the path of Pagy files like templates or dictionaries
  def self.root
    @root ||= Pathname.new(__dir__).freeze
  end

  # default vars
  VARS = { page: 1, items: 20, outset: 0, size: [1, 4, 4, 1], page_param: :page,              # rubocop:disable Style/MutableConstant
           params: {}, anchor: '', link_extra: '', i18n_key: 'pagy.item_name', cycle: false }

  attr_reader :count, :page, :items, :vars, :pages, :last, :offset, :from, :to, :prev, :next

  INSTANCE_VARS_MIN = { count: 0, items: 1, page: 1, outset: 0 }.freeze

  # Merge and validate the options, do some simple arithmetic and set the instance variables
  def initialize(vars)
    @vars = VARS.merge( vars.delete_if{|_,v| v.nil? || v == '' } )

    INSTANCE_VARS_MIN.each do |name,min|
      raise VariableError.new(self), "expected :#{name} >= #{min}; got #{@vars[name].inspect}" \
            unless @vars[name] && instance_variable_set(:"@#{name}", @vars[name].to_i) >= min
    end
    @pages = @last = [(@count.to_f / @items).ceil, 1].max
    raise OverflowError.new(self), "expected :page in 1..#{@last}; got #{@page.inspect}" if @page > @last

    @offset = @items * (@page - 1) + @outset
    @items  = @count - ((@pages-1) * @items) if @page == @last && @count.positive?
    @from   = @count.zero? ? 0 : @offset + 1 - @outset
    @to     = @count.zero? ? 0 : @offset + @items - @outset
    @prev   = (@page-1 unless @page == 1)
    @next   = @page == @last ? (1 if @vars[:cycle]) : @page + 1
  end

  # Return the array of page numbers and :gap items e.g. [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
  def series(size=@vars[:size])
    return [] if size.empty?
    raise VariableError.new(self), "expected 4 items >= 0 in :size; got #{size.inspect}" \
          unless size.size == 4 && size.all?{ |num| num >= 0 rescue false }  # rubocop:disable Style/RescueModifier

    [].tap do |series|
      [ *0..size[0],                                   # initial pages from 0
        *@page-size[1]..@page+size[2],                 # around current page
        *@last-size[3]+1..@last+1                      # final pages till @last+1
      ].sort!.each_cons(2) do |left, right|            # sort and loop by 2
        next if left.negative? || left == right        # skip out of range and duplicates
        break if left > @last                          # break if out of @last boundary
        case right
        when left+1 then series.push(left)             # no gap     -> no additions
        when left+2 then series.push(left, left+1)     # 1 page gap -> fill with missing page
        else             series.push(left, :gap)       # n page gap -> add gap
        end
      end
      series.shift                                     # shift the start boundary (0)
      series[series.index(@page)] = @page.to_s         # convert the current page to String
    end
  end

end

require 'pagy/backend'
require 'pagy/frontend'
require 'pagy/exceptions'
