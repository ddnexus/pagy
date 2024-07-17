# See Pagy::Countless API documentation: https://ddnexus.github.io/pagy/docs/api/countless
# frozen_string_literal: true

class Pagy # :nodoc:
  # No need to know the count to paginate
  class Countless < Pagy
    # Merge and validate the options, do some simple arithmetic and set a few instance variables
    def initialize(**vars) # rubocop:disable Lint/MissingSuper
      assign_vars(DEFAULT, vars)
      assign_and_check(page: 1, outset: 0)
      assign_limit
      assign_offset
    end

    # Finalize the instance variables based on the fetched size
    def finalize(fetched_size)
      raise OverflowError.new(self, :page, "to be < #{@page}", @page) if fetched_size.zero? && @page > 1

      @last = fetched_size > @limit ? @page + 1 : @page
      @last = @vars[:max_pages] if @vars[:max_pages] && @last > @vars[:max_pages]
      check_overflow
      @in   = [fetched_size, @limit].min
      @from = @in.zero? ? 0 : @offset - @outset + 1
      @to   = @offset - @outset + @in
      assign_prev_and_next
      self
    end
  end

  module SeriesOverride # :nodoc:
    # Override the original series.
    # Return nil if :countless_minimal is enabled
    def series(**)
      super unless @vars[:countless_minimal]
    end
  end
  prepend SeriesOverride
end
