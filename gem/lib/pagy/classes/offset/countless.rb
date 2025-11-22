# frozen_string_literal: true

class Pagy
  class Offset
    # Offset pagination without a count
    class Countless < Offset
      def initialize(**) # rubocop:disable Lint/MissingSuper
        assign_options(**)
        assign_and_check(limit: 1, page: 1)
        @page = upto_max_pages(@page)
        assign_offset
        assign_last unless @options[:headless]
      end

      def records(collection)
        return super if @options[:headless]

        fetched = collection.offset(@offset).limit(@limit + 1).to_a # eager load limit + 1
        finalize(fetched.size)                                      # finalize the pagy object
        fetched[0, @limit]                                          # ignore the extra item
      end

      protected

      def countless? = true

      def upto_max_pages(value)
        return value unless @options[:max_pages]

        [value, @options[:max_pages]].min
      end

      def assign_last
        @last = @options[:last] ? upto_max_pages(@options[:last].to_i) : @page
      end

      # Finalize the instance variables based on the fetched size
      def finalize(fetched_size)
        return self unless in_range? { fetched_size.positive? || @page == 1 }

        if @last && @page < @last # visited page
          @last = @page unless fetched_size > @limit # set last if last page
        else
          @last = upto_max_pages(fetched_size > @limit ? @page + 1 : @page)
        end
        @in   = [fetched_size, @limit].min
        @from = @in.zero? ? 0 : @offset + 1
        @to   = @offset + @in
        assign_previous_and_next
        self
      end
    end
  end
end
