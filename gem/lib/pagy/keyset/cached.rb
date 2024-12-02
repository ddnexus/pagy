# See Pagy::Countless API documentation: https://ddnexus.github.io/pagy/docs/api/keyset/for_ui
# frozen_string_literal: true

require_relative '../keyset'
require 'digest/sha2'

class Pagy # :nodoc:
  class Keyset
    # Implement wicked-fast keyset pagination for UI by using numeric pages that work with regular pagy navs.
    class Cached < Keyset
      include SharedMethodsForUI

      # Finalize the instance variables needed for the UI
      def initialize(set, **vars)
        super
        # Ensure next is called, so the last page used by the UI helpers is known
        self.next
        @prev   = @page - 1 unless @page == 1
        @last   = @cursors.size - 1 # 1-based array size
        @in     = @records.size
        @offset = @limit * (@page - 1)  # may not be accurate
        @from   = @in.zero? ? 0 : @offset + 1
        @to     = @offset + @in
      end

      # Get the cursor from the cache, not the page param
      def assign_cursor
        @cursor = @cursors[@page]
      end

      # Assign a numeric page param
      def assign_page
        assign_and_check(page: 1)
      end

      # Add the default variables required by the UI
      def default
        { **super, **DEFAULT.slice(:ends, :page, :size), query_key: [] }
      end

      # Return the next page; cache it if it's missing
      def next
        records
        return if !@more || (@vars[:max_pages] && @last > vars[:max_pages])

        @next ||= (@page + 1).tap do |next_page|
                    @cursors[next_page] ||= next_cursor
                  end
      end

      # Set up the cache and check for OverflowError
      def setup_cache
        @vars[:cache_key] ||= ->(vars) { vars.slice(:limit).to_json }
        key      = @vars[:cache_key].is_a?(Proc) ? @vars[:cache_key].(@vars) : @vars[:cache_key]
        @key     = "pagy-#{Digest::SHA2.hexdigest(key)}"
        @cache   = @vars[:cache]
        @cursors = @cache[@key] ||= [nil, nil]  # 1-based array; first cursor is nil
        last     = @cursors.size - 1
        raise OverflowError.new(self, :page, "in 1..#{last}", @page) if @page > last # last before next
      end
    end
  end
end
