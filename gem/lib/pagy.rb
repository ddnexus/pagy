# See Pagy API documentation: https://ddnexus.github.io/pagy/docs/api/pagy
# frozen_string_literal: true

require 'pathname'
require_relative 'pagy/autoloading'

# Top superclass: it should define only what's common to all the subclasses
class Pagy
  VERSION     = '9.3.3'
  PAGE_TOKEN  = 'P '
  LABEL_TOKEN = 'L'
  LIMIT_TOKEN = 'L '
  A_TAG       = '<a href="#" style="display: none;">#</a>'
  DEFAULT     = { limit: 20, # rubocop:disable Style/MutableConstant
                  page_sym: :page }
  # Gem root pathname to get the path of Pagy files stylesheets, javascripts, apps, locales, etc.
  def self.root
    @root ||= Pathname.new(__dir__).parent.freeze
  end

  attr_reader :page, :limit, :vars

  # Validates and assign the passed vars: var must be present and value.to_i must be >= to min
  def assign_and_check(name_min)
    name_min.each do |name, min|
      raise VariableError.new(self, name, ">= #{min}", @vars[name]) \
      unless @vars[name]&.respond_to?(:to_i) && instance_variable_set(:"@#{name}", @vars[name].to_i) >= min
    end
  end

  # Assign @limit (overridden by the gearbox extra)
  def assign_limit
    assign_and_check(limit: 1)
  end

  # Assign @vars
  def assign_vars(vars)
    cclass  = self.class
    default = cclass::DEFAULT
    while cclass != Pagy
      cclass  = cclass.superclass
      default = cclass::DEFAULT.merge(default)
    end
    @vars   = { **default, **vars.delete_if { |k, v| default.key?(k) && (v.nil? || v == '') } }
  end

  # Shared with KeysetForUI
  module SharedUIMethods
    attr_reader :in, :last, :prev
    alias pages last

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
          left  = ((size - 1) / 2.0).floor # left half might be 1 page shorter for even size
          start = if @page <= left # beginning pages
                    1
                  elsif @page > (@last - size + left) # end pages
                    @last - size + 1
                  else
                    # intermediate pages
                    @page - left
                  end
          series.push(*start...start + size)
          # Set first and last pages plus gaps when needed, respecting the size
          if vars[:ends] && size >= 7
            series[0]  = 1
            series[1]  = :gap unless series[1] == 2
            series[-2] = :gap unless series[-2] == @last - 1
            series[-1] = @last
          end
        end
        series[series.index(@page)] = @page.to_s unless @overflow # overflow has no current page
      end
    end

    # `Pagy` instance method used by the `pagy*_nav_js` helpers.
    # Return the reverse sorted array of widths, series, and labels generated from the :steps hash
    # Notice: if :steps is false it will use the single {0 => @vars[:size]} size
    def sequels(steps: @vars[:steps] || { 0 => @vars[:size] }, **_)
      raise VariableError.new(self, :steps, 'to define the 0 width', steps) unless steps.key?(0)

      widths, series = steps.sort.reverse.map { |width, size| [width, series(size:)] }.transpose
      [widths, series, label_sequels(series)]
    end

    # Support for the Calendar API
    def label_sequels(*); end
  end
  include Autoloading
end

require_relative 'pagy/exceptions'
