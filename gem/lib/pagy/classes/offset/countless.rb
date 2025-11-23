# frozen_string_literal: true

class Pagy
  class Offset
    # Offset pagination without a count
    class Countless < Offset
      def initialize(**) # rubocop:disable Lint/MissingSuper
        assign_options(**)
        assign_and_check(limit: 1, page: 1)
        @page = upto_max_pages(@page)
        @last = upto_max_pages(@options[:last]) unless @options[:headless]
        assign_offset
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
        return value unless value && @options[:max_pages]

        [value, @options[:max_pages]].min
      end

      # Finalize the instance variables based on the fetched size
      def finalize(fetched_size)
        @count = 0 if fetched_size.zero? && @page == 1  # empty records (trigger the right info message for known 0 count)
        return self unless in_range? { fetched_size.positive? || @page == 1 }

        past = @last && @page < @last     # this page has been past
        more = fetched_size > @limit      # more pages after this one
        unless past && more
          @last = upto_max_pages(more ? @page + 1 : @page)
        end
        @in   = [fetched_size, @limit].min
        @from = @in.zero? ? 0 : @offset + 1
        @to   = @offset + @in
        assign_previous_and_next
        self
      end

      # Called by false in_range?
      def assign_empty_page_variables
        @in = @from = @to = 0     # options relative to the actual page
        if @page > @last
          # @page     = @last
          @previous = @last
        else
          @last = @page
          assign_previous_and_next
        end
      end
    end
  end
end
