# frozen_string_literal: true

class Pagy
  class Offset
    # No need to know the count to paginate
    class Countless < Offset
      DEFAULT = { countless_minimal: false } # rubocop:disable Style/MutableConstant

      # Merge and validate the options, do some simple arithmetic and set a few instance variables
      def initialize(**vars) # rubocop:disable Lint/MissingSuper
        assign_vars(vars)
        assign_and_check(page: 1, outset: 0)
        assign_limit
        assign_offset
        @last = vars[:last].to_i
      end

      def self.predict_last? = false

      def page_for_url(page) = "#{page}+#{@last}"

      # Finalize the instance variables based on the fetched size
      def finalize(fetched_size)
        raise OverflowError.new(self, :page, "to be < #{@page}", @page) if fetched_size.zero? && @page > 1

        @last = fetched_size > @limit ? @page + 1 : @page unless @last && @page < @last
        @last = @vars[:max_pages] if @vars[:max_pages] && @last > @vars[:max_pages]
        raise OverflowError.new(self, :page, "in 1..#{@last}", @page) if @page > @last

        @in   = [fetched_size, @limit].min
        @from = @in.zero? ? 0 : @offset - @outset + 1
        @to   = @offset - @outset + @in
        assign_prev_and_next
        self
      rescue OverflowError
        @overflow = true
        raise unless @vars[:overflow] == :empty_page

        @offset      = @limit = @from = @to = 0 # vars relative to the actual page
        @vars[:size] = 0 # no page in the series
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
