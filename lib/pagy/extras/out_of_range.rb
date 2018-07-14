class Pagy

  VARS[:out_of_range_mode] = :last_page

  def out_of_range?; @out_of_range end

  module OutOfRange

    def initialize(vars)
      super
    rescue OutOfRangeError
      @out_of_range = true                        # add the out_of_range flag
      case @vars[:out_of_range_mode]
      when :exception
        raise                                     # same as without the extra
      when :last_page
        initial_page = @vars[:page]               # save the very initial page (even after re-run)
        super(vars.merge!(page: @last))           # re-run with the last page
        @vars[:page] = initial_page               # restore the inital page
      when :empty_page
        @offset = @items = @from = @to = 0        # vars relative to the actual page
        @prev = @last                             # prev relative to the actual page
        extend(Series)                            # special series for :empty_page
      else
        raise ArgumentError, "expected :out_of_range_mode variable in [:last_page, :empty_page, :exception]; got #{@vars[:out_of_range_mode].inspect}"
      end
    end

  end

  module Series

    def series(size=@vars[:size])
      @page = @last                               # series for last page
      super(size).tap do |s|                      # call original series
        s[s.index(@page.to_s)] = @page            # string to integer (i.e. no current page)
        @page = @vars[:page]                      # restore the actual page
      end
    end

  end

  prepend OutOfRange

end
