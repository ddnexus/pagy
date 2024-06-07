# See Pagy API documentation: https://ddnexus.github.io/pagy/docs/api/pagy
# frozen_string_literal: true

require 'pathname'

# Core class
class Pagy
  VERSION = '8.4.4'

  # Gem root pathname to get the path of Pagy files stylesheets, javascripts, apps, locales, etc.
  def self.root
    @root ||= Pathname.new(__dir__).parent.freeze
  end

  # Core default: constant for easy access, but mutable for customizable defaults
  DEFAULT = { page:       1, # rubocop:disable Style/MutableConstant
              items:      20,
              outset:     0,
              size:       7,
              cycle:      false,
              count_args: [:all],  # AR friendly
              page_param: :page }

  attr_reader :count, :page, :items, :vars, :last, :offset, :in, :from, :to, :prev, :next
  alias pages last

  # Merge and validate the options, do some simple arithmetic and set the instance variables
  def initialize(vars)
    normalize_vars(vars)
    setup_vars(count: 0, page: 1, outset: 0)
    setup_items_var
    setup_last_var
    raise OverflowError.new(self, :page, "in 1..#{@last}", @page) if @page > @last

    setup_offset_var
    @from = [@offset - @outset + 1, @count].min
    @to   = [@offset - @outset + @items, @count].min
    @in   = [@to - @from + 1, @count].min
    @prev = (@page - 1 unless @page == 1)
    @next = @page == @last ? (1 if @vars[:cycle]) : @page + 1
  end

  # Return the array of page numbers and :gap items e.g. [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
  def series(size: @vars[:size], **_)
    series = []
    if size.is_a?(Array) && size.size == 4 && size.all? { |num| !num.negative? rescue false } # rubocop:disable Style/RescueModifier
      # This algorithm is up to ~5x faster and ~2.3x lighter than the previous one (pagy < 4.3)
      left_gap_start  =     1 + size[0]
      left_gap_end    = @page - size[1] - 1
      right_gap_start = @page + size[2] + 1
      right_gap_end   = @last - size[3]
      left_gap_end    = right_gap_end  if left_gap_end   > right_gap_end
      right_gap_start = left_gap_start if left_gap_start > right_gap_start
      start           = 1
      if (left_gap_end - left_gap_start).positive?
        series.push(*start...left_gap_start, :gap)
        start = left_gap_end + 1
      end
      if (right_gap_end - right_gap_start).positive?
        series.push(*start...right_gap_start, :gap)
        start = right_gap_end + 1
      end
      series.push(*start..@last)
    elsif size.is_a?(Integer) && size.positive?    # only central series
      # The simplest and fastest algorithm
      size  = @last if size > @last                # reduce the max size to @last
      left  = ((size - 1) / 2.0).floor             # left half might be 1 page shorter for even size
      start = if @page <= left                     # beginning pages
                1
              elsif @page > @last - (size - left)  # end pages
                @last - size + 1
              else                                 # intermediate pages
                @page - left
              end
      series = (start..start + size - 1).to_a
    else
      return [] if size.empty?

      raise VariableError.new(self, :size, 'to be a single positive Integer or an Array of 4', size)
    end
    series[series.index(@page)] = @page.to_s
    series
  end

  # Label for any page. Allow the customization of the output (overridden by the calendar extra)
  def label_for(page)
    page.to_s
  end

  # Label for the current page. Allow the customization of the output (overridden by the calendar extra)
  def label
    @page.to_s
  end

  protected

  # Apply defaults, cleanup blanks and set @vars
  def normalize_vars(vars)
    @vars = DEFAULT.merge(vars.delete_if { |k, v| DEFAULT.key?(k) && (v.nil? || v == '') })
  end

  # Setup and validates the passed vars: var must be present and value.to_i must be >= to min
  def setup_vars(name_min)
    name_min.each do |name, min|
      raise VariableError.new(self, name, ">= #{min}", @vars[name]) \
            unless @vars[name]&.respond_to?(:to_i) && instance_variable_set(:"@#{name}", @vars[name].to_i) >= min
    end
  end

  # Setup @items (overridden by the gearbox extra)
  def setup_items_var
    setup_vars(items: 1)
  end

  # Setup @last (overridden by the gearbox extra)
  def setup_last_var
    @last = [(@count.to_f / @items).ceil, 1].max
    @last = vars[:max_pages] if vars[:max_pages] && @last > vars[:max_pages]
  end
  alias setup_pages_var setup_last_var

  # Setup @offset based on the :gearbox_items variable
  def setup_offset_var
    @offset = (@items * (@page - 1)) + @outset  # may be already set from gear_box
  end
end

require_relative 'pagy/backend'
require_relative 'pagy/frontend'
require_relative 'pagy/exceptions'
