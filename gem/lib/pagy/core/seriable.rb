# frozen_string_literal: true

class Pagy
  module Core
    # Add methods enabling navigation with *_nav and *_nav_js helpers
    module Seriable
      LENGTH = 7

      # Label for any page. Allow the customization of the output (overridden by the calendar)
      def label(page: @page, **) = page.to_s

      # Return the array of page numbers and :gap e.g. [1, :gap, 8, "9", 10, :gap, 36]
      def series(length: @options[:length] || LENGTH, compact: @options[:compact], **)
        raise OptionError.new(self, :length, 'to be an Integer >= 0', length) \
              unless length.is_a?(Integer) && length >= 0
        return [] if length.zero?

        [].tap do |series|
          if length >= @last
            series.push(*1..@last)
          else
            left  = ((length - 1) / 2.0).floor            # left half might be 1 page shorter for even length
            start = if @page <= left                      # beginning pages
                      1
                    elsif @page > (@last - length + left) # end pages
                      @last - length + 1
                    else                                  # intermediate pages
                      @page - left
                    end
            series.push(*start...start + length)
            unless compact || length < LENGTH             # Set first, last and gaps when needed
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

      # `Pagy` instance method used by the `pagy*_nav_js` helpers.
      # Return the reverse sorted array of widths, series, and labels generated from the :steps hash
      # Notice: if :steps is false it will use the single {0 => @options[:length]} length
      def sequels(steps: @options[:steps] || { 0 => @options[:length] || LENGTH }, **)
        raise OptionError.new(self, :steps, 'to define the 0 width', steps) unless steps.key?(0)

        widths, series = steps.sort.reverse.map { |width, length| [width, series(length:)] }.transpose
        [widths, series, label_sequels(series)]
      end

      # Support for the Calendar API
      def label_sequels(*); end
    end
  end
end
