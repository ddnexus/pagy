# frozen_string_literal: true

class Pagy
  class Offset
    # No need to know the count to paginate
    class Countless < Offset
      # Merge and validate the options, do some simple arithmetic and set a few instance variables
      def initialize(**opts) # rubocop:disable Lint/MissingSuper
        assign_opts(opts)
        assign_and_check(limit: 1, page: 1)
        assign_last
        assign_offset
      end

      def countless? = true

      def assign_last
        @last = (@opts[:last] || 1).to_i
        @last = @page = @opts[:max_pages] if @opts[:max_pages] && (@last > @opts[:max_pages] || @page > @opts[:max_pages])
      end

      def page_for_url(page) = [page || 1, @last].join('+')

      # Finalize the instance variables based on the fetched size
      def finalize(fetched_size)
        return self unless in_range? { fetched_size.positive? || @page == 1 }

        if @last && @page < @last # visited page
          @last = @page unless fetched_size > @limit # set last if last page
        else
          @last = fetched_size > @limit ? @page + 1 : @page unless @page == @opts[:max_pages]
        end

        @in   = [fetched_size, @limit].min
        @from = @in.zero? ? 0 : @offset + 1
        @to   = @offset + @in
        assign_prev_and_next
        self
      end
    end

    module SeriesOverride # :nodoc:
      # Override the original series.
      # Return nil if :countless_minimal is enabled
      def series(**)
        super unless @opts[:countless_minimal]
      end
    end
    prepend SeriesOverride
  end
end
