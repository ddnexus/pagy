# See Pagy::Countless API documentation: https://ddnexus.github.io/pagy/api/countless
# frozen_string_literal: true

require 'pagy'

class Pagy
  # No need to know the count to paginate
  class Countless < Pagy
    # Merge and validate the options, do some simple arithmetic and set a few instance variables
    def initialize(vars = {}) # rubocop:disable Lint/MissingSuper
      normalize_vars(vars)
      setup_vars(page: 1, outset: 0)
      setup_items_var
      setup_params_var
      @offset = (@items * (@page - 1)) + @outset
    end

    # Finalize the instance variables based on the fetched size
    def finalize(fetched_size)
      raise OverflowError.new(self, :page, "to be < #{@page}", @page) if fetched_size.zero? && @page > 1

      @pages = @last = (fetched_size > @items ? @page + 1 : @page)
      @in    = [fetched_size, @items].min
      @from  = @in.zero? ? 0 : @offset - @outset + 1
      @to    = @offset - @outset + @in
      @prev  = (@page - 1 unless @page == 1)
      @next  = @page == @last ? (1 if @vars[:cycle]) : @page + 1
      self
    end

    # Override the original series.
    # Return nil if :countless_minimal is enabled
    def series(_size = @vars[:size])
      super unless @vars[:countless_minimal]
    end
  end
end
