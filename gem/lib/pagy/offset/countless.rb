# frozen_string_literal: true

class Pagy
  class Offset
    # Offset pagination without a count
    class Countless < Offset
      def initialize(**) # rubocop:disable Lint/MissingSuper
        assign_options(**)
        assign_and_check(limit: 1, page: 1)
        assign_last
        assign_offset
      end

      def records(collection)
        return super if @options[:headless]

        fetched = collection.offset(@offset).limit(@limit + 1).to_a # eager load limit + 1
        finalize(fetched.size)                                      # finalize the pagy object
        fetched[0, @limit]                                          # ignore the extra item
      end

      protected

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

      def countless? = true

      def assign_last
        @last = (@options[:last] || 1).to_i
        @last = @page = @options[:max_pages] \
        if @options[:max_pages] && (@last > @options[:max_pages] || @page > @options[:max_pages])
      end
    end

    module SeriesOverride # :nodoc:
      # Override the original series.
      # Return nil if :headless is enabled
      def series(**)
        super unless @options[:headless]
      end
    end
    prepend SeriesOverride
  end
end
