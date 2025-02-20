# frozen_string_literal: true

class Pagy
  SERIES_LENGTH = 7

  protected

  # Return the array of page numbers and :gap e.g. [1, :gap, 8, "9", 10, :gap, 36]
  def series(length: @options[:length] || SERIES_LENGTH, compact: @options[:compact], **)
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
        unless compact || length < SERIES_LENGTH             # Set first, last and :gap when needed
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
end
