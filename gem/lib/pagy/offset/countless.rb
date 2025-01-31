# frozen_string_literal: true

class Pagy
  class Offset
    # No need to know the count to paginate
    class Countless < Offset
      # Merge and validate the options, do some simple arithmetic and set a few instance variables
      def initialize(**) # rubocop:disable Lint/MissingSuper
        assign_options(**)
        assign_and_check(limit: 1, page: 1)
        assign_last
        assign_offset
      end

      def countless? = true

      def assign_last
        @last = (@options[:last] || 1).to_i
        @last = @page = @options[:max_pages] \
          if @options[:max_pages] && (@last > @options[:max_pages] || @page > @options[:max_pages])
      end

      def page_for_url(page) = [page || 1, @last].join('+')

      # Finalize the instance variables based on the fetched size
      def finalize(fetched_size)
        return self unless in_range? { fetched_size.positive? || @page == 1 }

        if @last && @page < @last # visited page
          @last = @page unless fetched_size > @limit # set last if last page
        else
          @last = fetched_size > @limit ? @page + 1 : @page unless @page == @options[:max_pages]
        end

        @in   = [fetched_size, @limit].min
        @from = @in.zero? ? 0 : @offset + 1
        @to   = @offset + @in
        assign_previous_and_next
        self
      end
    end

    module SeriesOverride # :nodoc:
      # Override the original series.
      # Return nil if :countless_minimal is enabled
      def series(**)
        super unless @options[:countless_minimal]
      end
    end
    prepend SeriesOverride
  end
end
