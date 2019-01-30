# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/overflow
# frozen_string_literal: true

class Pagy

  VARS[:overflow] = :empty_page

  def overflow?; @overflow end

  alias :initialize_without_overflow :initialize
  def initialize_with_overflow(vars)
    @overflow ||= false                         # don't override if :last_page re-run the method after an overflow
    initialize_without_overflow(vars)
  rescue OverflowError
    @overflow = true                            # add the overflow flag
    case @vars[:overflow]
    when :exception
      raise                                     # same as without the extra
    when :last_page
      initial_page = @vars[:page]               # save the very initial page (even after re-run)
      initialize(vars.merge!(page: @last))      # re-run with the last page
      @vars[:page] = initial_page               # restore the inital page
    when :empty_page
      @offset = @items = @from = @to = 0        # vars relative to the actual page
      @prev = @last                             # prev relative to the actual page
      extend(Series)                            # special series for :empty_page
    else
      raise ArgumentError, "expected :overflow variable in [:last_page, :empty_page, :exception]; got #{@vars[:overflow].inspect}"
    end
  end
  alias :initialize :initialize_with_overflow

  module Series
    def series(size=@vars[:size])
      @page = @last                               # series for last page
      super(size).tap do |s|                      # call original series
        s[s.index(@page.to_s)] = @page            # string to integer (i.e. no current page)
        @page = @vars[:page]                      # restore the actual page
      end
    end
  end


  # support for Pagy::Countless
  if defined?(Pagy::Countless)
    class Countless

      alias :finalize_without_overflow :finalize
      def finalize_with_overflow(items)
        @overflow = false
        finalize_without_overflow(items)
      rescue OverflowError
        @overflow = true                            # add the overflow flag
        case @vars[:overflow]
        when :exception
          raise                                     # same as without the extra
        when :empty_page
          @offset = @items = @from = @to = 0        # vars relative to the actual page
          @vars[:size] = []                         # no page in the series
          self
        else
          raise ArgumentError, "expected :overflow variable in [:empty_page, :exception]; got #{@vars[:overflow].inspect}"
        end
      end
      alias :finalize :finalize_with_overflow

    end
  end

end
