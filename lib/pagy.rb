require 'pagy/version'
require 'pagy/extensions' # use autoload on extensions
require 'ostruct'

# This class represents the metrics (i.e. the way of measuring) of a "page",
# i.e. a subset of a main collection. In this case the "page" is simply the subset,
# and it should not be confused with a web page, or anything related with the display of the subset.
# For Pagy, pagination and display are totally separate matters.
#
# So, since the "page" is just a subset of items, its metrics are plain non-negative integers that describe
# some measure related to the page. For example: the ordinal number of the current page,
# the total items in the items-collection, the previous and next pages, the pages around the current page,
# the starting and ending items, etc.
#
# By using the Pagy object in the pagination template, you can build your navigation system with no effort.
#
class Pagy

  # defaul global options
  GlobalOptions = OpenStruct.new max_items_per_page:  20,    # number of items used to divide the item-collection into pages
                                 max_beginning_pages: 0,     # max number of #beginning_pages
                                 max_ending_pages:    0,     # max number of #ending_pages
                                 max_before_pages:    2,     # max number of #before_pages
                                 max_after_pages:     2,     # max number of #after_pages
                                 overlapping_pages?:  false  # false: remove the #ending_pages already in the #after_pages array
                                                             # and/or the #beginning_pages already in the #before_pages array

  # configure the global options
  def self.configure(*, &block)
    block.call GlobalOptions
  end

  attr_reader :total_items            # total items in the collection
  attr_reader :page                   # ordinal number of the page in the page-collection
  attr_reader :options                # options to customize metrics calculation

  # item-collection: the collection of items from 1 to #total_items (e.g.: the whole non-paginated collection of results)
  # page-items: the items in the page (e.g.: the subset of paginated result displayed in the page)
  # page-collection: the collection of pages from 1 to #total_pages

  # constructor with validation for the pagy object
  def initialize(total_items, page, options={})
    non_negative_integer = -> (n) { n.is_a?(Integer) && !n.negative? }

    if non_negative_integer.call(total_items)
      @total_items = total_items
    else
      raise ArgumentError, "total_item expected to be a non-negative integer; got #{total_items.inspect}."
    end

    options = GlobalOptions.to_h.merge(options).freeze unless options.frozen?
    metrics = [:max_items_per_page, :max_beginning_pages, :max_ending_pages,
               :max_before_pages, :max_after_pages]
    metrics.each do |name|
      unless non_negative_integer.call(options[name])
        raise ArgumentError, "#{name} option expected to be a non-negative integer; got #{options[name].inspect}."
      end
    end
    @options = options

    if page.is_a?(Integer) && page.positive? && page <= total_pages
      @page = page
    else
      raise ArgumentError, "page expected to be an integer in the range 1..#{total_pages}; got #{page.inspect}."
    end
  end

  # supplies direct option readers
  def method_missing(meth, *args, &block)
    @options.has_key?(meth) ? @options[meth] : super
  end

  # respond_to direct option readers
  def respond_to?(meth, include_private=false)
    @options.has_key?(meth) || super
  end

  # items to offset
  def offset
    @offset ||= @options[:max_items_per_page] * ((@page) - 1)
  end

  # maximum number of items per page
  def limit
    @options[:max_items_per_page]
  end

  # total number of pages in the page-collection
  def total_pages
    @total_pages ||= (@total_items.to_f / @options[:max_items_per_page]).ceil
  end

  # the page starts from this item (position in the item-collection)
  def from_item
    @from_item ||= offset + 1
  end

  # the page ends with this item (position in the item-collection)
  def to_item
    @to_item ||= begin
                   ending = offset + @options[:max_items_per_page]
                   (ending > @total_items) ? @total_items : ending
                 end
  end

  # first page of the page-collection (obviously 1, but it's here for verbose simmetry)
  def first_page
    1
  end

  # last page of the page-collection
  alias_method :last_page, :total_pages


  # is the page the first page of the page-collection?
  def first_page?
    @is_first_page ||= @page == 1
  end

  # is the current page the last page of the page-collection?
  def last_page?
    @is_last_page ||= @page == last_page
  end

  # the page before the curent page (nil if first_page? is true)
  def previous_page
    @previous_page ||= (@page > 1) ? (@page - 1) : nil
  end

  # the page after the current page (nil if last_page? is true)
  def next_page
    @next_page ||= last_page? ? nil : (@page + 1)
  end

  # array containing the :max_before_pages right before the (current) page
  def before_pages
    @before_pages ||= begin
                        return [] if @options[:max_before_pages].zero? || first_page?
                        start_position = @page - @options[:max_before_pages]
                        start_position = 1 if start_position < 1
                        (start_position..(@page - 1)).to_a
                      end
  end

  # array containing the :max_after_pages right after the (current) page
  def after_pages
    @after_pages ||= begin
                       return [] if @options[:max_after_pages].zero? || last_page?
                       end_position = @page + @options[:max_after_pages]
                       end_position = last_page if end_position > last_page
                       ((@page + 1)..end_position).to_a
                     end
  end

  # array containing the :max_beginning_pages beginning from the first_page
  def beginning_pages
    @beginning_pages ||= begin
                          return [] if @options[:max_beginning_pages].zero? || first_page?
                          end_position   = @options[:max_beginning_pages]
                          end_position   = @page - 1 if @page <= end_position
                          beginning_pages = (1..end_position).to_a
                          @options[:overlapping_pages?] ?  beginning_pages : (beginning_pages - before_pages)
                        end
  end

  # array containing the :max_ending_pages ending with the last_page
  def ending_pages
    @ending_pages ||= begin
                        return [] if @options[:max_ending_pages].zero? || last_page?
                        start_position = last_page - @options[:max_ending_pages] + 1
                        start_position = @page + 1 if @page >= start_position
                        ending_pages   = (start_position..last_page).to_a
                        @options[:overlapping_pages?] ? ending_pages : (ending_pages - after_pages)
                      end
  end

  # is there a gap between beginning_pages and before_pages?
  def before_gap?
    @has_before_gap ||= begin
                        if beginning_pages.empty? || before_pages.empty?
                          false
                        else
                          (beginning_pages.last + 1) < before_pages.first
                        end
                      end
  end

  # is there a gap between after_pages and ending_pages?
  def after_gap?
    @has_after_gap ||= begin
                         if ending_pages.empty? || after_pages.empty?
                           false
                         else
                           (after_pages.last + 1) < ending_pages.first
                         end
                       end
  end

  def inspect
    super =~ /#<([^\s]+)/
    str =  "#<#{$1} "
    str << "x:#{@options[:max_items_per_page]} "
    str << "page:#{@page}/#{total_pages} "
    str << "pages:[#{beginning_pages.join('-')}]"
    str << '~' if before_gap?
    str << "[#{before_pages.join('-')}]"
    str << "(#{@page})"
    str << "[#{after_pages.join('-')}]"
    str << '~' if after_gap?
    str << "[#{ending_pages.join('-')}] "
    str << "items:(#{from_item}..#{to_item})/#{total_items}>"
  end

end
