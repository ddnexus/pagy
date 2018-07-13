class Pagy

  VARS[:out_of_range_mode] = :last_page

  def out_of_range?; @out_of_range end

  alias :create :initialize

  def initialize(vars)
    create(vars)
  rescue OutOfRangeError => e
    raise e if @vars[:out_of_range_mode] == :exception
    @out_of_range = true
    if @vars[:out_of_range_mode] == :last_page
      @page = @last                                 # set as last page
    elsif @vars[:out_of_range_mode] == :empty_page
      @offset = @items = @from = @to = 0            # vars relative to the actual page
      @prev = @last                                 # the prev is the last page
      define_singleton_method(:series) do |size=@vars[:size]|
        @page = @last                               # series for last page
        super(size).tap do |s|                      # call original series
          s[s.index(@page.to_s)] = @page            # string to integer (i.e. no current page)
          @page = @vars[:page]                      # restore the actual page
        end
      end
    end
  end

end
