# frozen_string_literal: true

class Pagy
  class Offset
    # No need to know the count to paginate
    class Countless < Offset
      # Merge and validate the options, do some simple arithmetic and set a few instance variables
      def initialize(**vars) # rubocop:disable Lint/MissingSuper
        assign_vars(vars)
        assign_and_check(page: 1, outset: 0)
        assign_limit  # TODO: assign directly
        assign_last
        assign_offset
      end

      def countless? = true

      def assign_last
        @last = (@vars[:last] || 1).to_i
        @last = @page = @vars[:max_pages] if @vars[:max_pages] && (@last > @vars[:max_pages] || @page > @vars[:max_pages])
      end

      def page_for_url(page) = [page || 1, @last].join('+')

      # Finalize the instance variables based on the fetched size
      def finalize(fetched_size)
        raise RangeError.new(self, :page, "to be < #{@page}", @page) if fetched_size.zero? && @page > 1

        if @last && @page < @last # visited page
          @last = @page unless fetched_size > @limit # set last if last page
        else
          @last = fetched_size > @limit ? @page + 1 : @page unless @page == @vars[:max_pages]
        end

        @in   = [fetched_size, @limit].min
        @from = @in.zero? ? 0 : @offset - @outset + 1
        @to   = @offset - @outset + @in
        assign_prev_and_next
        self
      rescue RangeError
        @range_rescued = true
        raise unless @vars[:range_rescue] == :empty_page

        @in = @from = @to = @offset = @limit = 0     # vars relative to the actual page
        @last = @page -= 1                           # self adjust at least by 1 less
        @prev = @last                                # @prev relative to the actual page
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
end
