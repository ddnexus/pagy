# frozen_string_literal: true

class Pagy
  # Add methods enabling navigation with *_nav and *_nav_js helpers
  module Seriable
    LENGTH = 7

    def self.included(including)
      including.alias_method :pages, :last
    end

    # Return the array of page numbers and :gap e.g. [1, :gap, 8, "9", 10, :gap, 36]
    def series(length: @options[:length] || LENGTH, compact: @options[:compact], **)
      raise OptionError.new(self, :length, 'to be an Integer >= 0', length) \
            unless length.is_a?(Integer) && length >= 0
      return [] if length.zero?

      [].tap do |series|
        if length >= @last
          series.push(*1..@last)
        else
          half  = (length - 1) / 2                      # the left half might be 1 page shorter when length is even
          start = if @page <= half                      # @page in the first half
                    1
                  elsif @page > (@last - length + half) # @page in the last half
                    @last - length + 1
                  else                                  # @page in the middle
                    @page - half
                  end
          series.push(*start...start + length)
          unless compact || length < LENGTH             # Set first, last and :gap when needed
            series[0]  = 1
            series[1]  = :gap unless series[1]  == 2
            series[-2] = :gap unless series[-2] == @last - 1
            series[-1] = @last
          end
        end
        current = series.index(@page)
        series[current] = @page.to_s if current
      end
    end

    # Return the reverse sorted array of widths, series, and labels generated from the :steps hash
    # If :steps is false it will use the single {0 => @options[:length]} length
    def sequels(steps: @options[:steps] || { 0 => @options[:length] || LENGTH }, **)
      raise OptionError.new(self, :steps, 'to define the 0 width', steps) unless steps.key?(0)

      widths, series = steps.sort.reverse.map { |width, length| [width, series(length:)] }.transpose
      [widths, series, page_labels(series)]
    end

    # Support for the Calendar API
    def page_labels(*); end
  end
end
