class Pagy

  VARS[:out_of_range_mode] = :last_page

  def out_of_range?; @out_of_range end

  module OutOfRange

    def initialize(vars)
      super
    rescue OutOfRangeError => e
      @out_of_range = true                            # adds the out_of_range flag
      raise e if @vars[:out_of_range_mode] == :exception
      if @vars[:out_of_range_mode] == :last_page
        @page = @last                                 # set as the last page
        finalize
      elsif @vars[:out_of_range_mode] == :empty_page
        @offset = @items = @from = @to = 0            # vars relative to the actual page
        @prev = @last
        extend(Series)
      else raise ArgumentError, "Unknown mode #{@vars[:out_of_range_mode]}"
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
