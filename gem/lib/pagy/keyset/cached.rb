# See Pagy::Countless API documentation: https://ddnexus.github.io/pagy/docs/api/keyset/cached
# frozen_string_literal: true

require_relative '../keyset'
require 'digest/sha2'

class Pagy # :nodoc:
  class Keyset
    # Implement wicked-fast keyset pagination for UI by using numeric pages that work with regular pagy navs.
    class Cached < Keyset
      class ActiveRecord < Cached
        include ActiveRecordAdapter
      end

      class Sequel < Cached
        include SequelAdapter
      end
      # Avoid params conflicts for composite filters
      NOT_PREFIX = 'not_'  # Prefix for NOT filter filter_params

      include SharedMethodsForUI

      # Finalize the instance variables needed for the UI
      def initialize(set, **vars)
        super
        # Ensure next is called, so the last page used by the UI helpers is known
        self.next
        @prev = @page - 1 unless @page == 1
        @last = @cutoffs.size - 1 # 1-based array size
        @in   = @records.size
      end

      # Get the cutoff from the cache
      def assign_cutoff
        @cutoff = @cutoffs[@page]
      end

      # Assign a numeric page
      def assign_page
        assign_and_check(page: 1)
      end

      # Generate different params when the next_cutoff is cached
      def assign_filter_params
        return super unless @next_cached_cutoff ||= @cutoffs[@page + 1] # return super only when it's the last page

        # Regular cutoff filter: it is missing for page 1 that doesn't have a cutoff.
        @filter_params = cutoff_to_params(@cutoff) if @cutoff

        # The NOT filter (exclude the records after the next cutoff) is used as a repacement of the LIMIT, which may become inaccurate for cached cutoffs.
        filter_params     = cutoff_to_params(@next_cached_cutoff, NOT_PREFIX)
        (@filter_params ||= {}).merge!(filter_params)
      end

      # Add the default variables required by the UI
      def default
        { **super, **DEFAULT.slice(:ends, :page, :size) }
      end

      # Remove the LIMIT when the next_cutoff is cached
      def fetch_records
        return super unless @next_cached_cutoff # super for the last page

        # The LIMIT is replaced by the NOT filter.
        # That keeps the fetching accurate also when records are added or removed from a page alredy visited
        @more = true
        @set.limit(nil).to_a
      end

      # Generate a filter between cutoffs when the next_cutoff is cached
      def filter_records_query
        return super unless @next_cached_cutoff # super for the last page

        # Generate a composite filter between:
        #   - The start of the set and the next cutoff (page == 1)
        #     Filter logic: NOT BEYOND_NEXT_CUTOFF
        #   - The current cutoff and the next cutoff (page > 1)
        #     Filter logic: BEYOND_CUTOFF AND NOT BEYOND_NEXT_CUTOFF
        # Notice: the fetch_records will execute without the LIMIT
        sql = +''
        # Generate the :on filter if flagged
        sql << "(#{super}) AND " if @cutoff
        # Add the NOT filter
        sql << "NOT (#{super(NOT_PREFIX)})"
      end

      # Return the next page number and cache the next_cutoff if it's missing
      def next
        records
        return if !@more || (@vars[:max_pages] && @page >= @vars[:max_pages])

        @next ||= (@page + 1).tap do |next_page|
                    @cutoffs[next_page] = next_cutoff unless @next_cached_cutoff
                  end
      end

      # Set up the cache and check for OverflowError.
      def setup_cache
        raise VariableError.new(self, :cache, 'to be a Hash-like object', @vars[:cache]) \
              unless @vars[:cache].respond_to?(:[]=) && @vars[:cache].respond_to?(:[])

        key = @vars[:cache_key].is_a?(Proc) ? @vars[:cache_key].(@vars) : @vars[:cache_key]
        raise VariableError.new(self, :cache_key, 'to be a String or a Proc returning a string', key) \
              unless key.is_a?(String) && !key.empty?

        @cutoffs = @vars[:cache][key] ||= [nil, nil]  # nil: 1-based array; nil: first cutoff is nil
        last     = @cutoffs.size - 1 # at this point it's not the @last for the UI (see initislizer)
        raise OverflowError.new(self, :page, "in 1..#{last}", @page) if @page > last
      end
    end
  end
end
