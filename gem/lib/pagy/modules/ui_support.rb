# frozen_string_literal: true

class Pagy
  module UISupport
    # Label for the current page. Allow the customization of the output (overridden by the calendar)
    def label = @page.to_s

    # Label for any page. Allow the customization of the output (overridden by the calendar)
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
end
