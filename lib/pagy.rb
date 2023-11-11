# See Pagy API documentation: https://ddnexus.github.io/pagy/docs/api/pagy
# frozen_string_literal: true

require 'pathname'

# Core class
class Pagy
  VERSION = '6.2.0'

  # Root pathname to get the path of Pagy files like templates or dictionaries
  def self.root
    @root ||= Pathname.new(__dir__).freeze
  end

  # Default core vars: constant for easy access, but mutable for customizable defaults
  DEFAULT = { page:       1, # rubocop:disable Style/MutableConstant
              items:      20,
              outset:     0,
              size:       [1, 4, 4, 1],
              page_param: :page,
              params:     {},
              fragment:   '',
              link_extra: '',
              i18n_key:   'pagy.item_name',
              cycle:      false,
              request_path: '' }

  attr_reader :count, :page, :items, :vars, :pages, :last, :offset, :in, :from, :to, :prev, :next, :params, :request_path

  # Merge and validate the options, do some simple arithmetic and set the instance variables
  def initialize(vars)
    normalize_vars(vars)
    setup_vars(count: 0, page: 1, outset: 0)
    setup_items_var
    setup_pages_var
    setup_offset_var
    setup_params_var
    setup_request_path_var
    raise OverflowError.new(self, :page, "in 1..#{@last}", @page) if @page > @last

    @from   = [@offset - @outset + 1, @count].min
    @to     = [@offset - @outset + @items, @count].min
    @in     = [@to - @from + 1, @count].min
    @prev   = (@page - 1 unless @page == 1)
    @next   = @page == @last ? (1 if @vars[:cycle]) : @page + 1
  end

  # Return the array of page numbers and :gap items e.g. [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
  def series(size: @vars[:size], **_)
    return [] if size.empty?
    raise VariableError.new(self, :size, 'to contain 4 items >= 0', size) \
          unless size.is_a?(Array) && size.size == 4 && size.all? { |num| !num.negative? rescue false } # rubocop:disable Style/RescueModifier

    # This algorithm is up to ~5x faster and ~2.3x lighter than the previous one (pagy < 4.3)
    left_gap_start  =     1 + size[0]   # rubocop:disable Layout/ExtraSpacing, Layout/SpaceAroundOperators
    left_gap_end    = @page - size[1] - 1
    right_gap_start = @page + size[2] + 1
    right_gap_end   = @last - size[3]
    left_gap_end    = right_gap_end  if left_gap_end   > right_gap_end
    right_gap_start = left_gap_start if left_gap_start > right_gap_start
    series          = []
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
    series[series.index(@page)] = @page.to_s
    series
  end

  # Allow the customization of the output (overridden by the calendar extra)
  def label_for(page)
    page.to_s
  end

  # Allow the customization of the output (overridden by the calendar extra)
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

  # Setup @pages and @last (overridden by the gearbox extra)
  def setup_pages_var
    @pages = @last = [(@count.to_f / @items).ceil, 1].max
  end

  # Setup @offset based on the :gearbox_items variable
  def setup_offset_var
    @offset = (@items * (@page - 1)) + @outset  # may be already set from gear_box
  end

  # Setup and validate @params
  def setup_params_var
    raise VariableError.new(self, :params, 'must be a Hash or a Proc', @params) \
          unless (@params = @vars[:params]).is_a?(Hash) || @params.is_a?(Proc)
  end

  def setup_request_path_var
    request_path = @vars[:request_path]
    return if request_path.to_s.empty?

    raise VariableError.new(self, :request_path, 'must be a bare path like "/foo"', request_path) \
          if !request_path.start_with?('/') || request_path.include?('?')

    @request_path = request_path
  end
end

require 'pagy/backend'
require 'pagy/frontend'
require 'pagy/exceptions'
