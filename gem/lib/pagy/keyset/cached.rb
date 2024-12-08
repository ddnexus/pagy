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
      # Avoid params conflicts in composite filters
      LIMIT_PREFIX = 'limit_'  # Prefix for cutoff_params

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

      # Assign different params if @limit_cutoff to support the composite LIMIT filter
      def assign_filter_params
        # @limit_cutoff is the cached cutoff for the next page
        return super unless @limit_cutoff ||= @cutoffs[@page + 1] # return super only when it's the last page

        # The regular cutoff params are missing for page 1 (which doesn't have a cutoff).
        @filter_params = cutoff_to_params(@cutoff) if @cutoff

        # The limit_cutoff params are preserved by prefixing them before merging
        filter_params     = cutoff_to_params(@limit_cutoff).transform_keys { |key| :"#{LIMIT_PREFIX}#{key}" }
        (@filter_params ||= {}).merge!(filter_params)
      end

      # Add the default variables required by the UI
      def default
        { **super, **DEFAULT.slice(:ends, :page, :size) }
      end

      # Remove the LIMIT if @limit_cutoff
      def fetch_records
        return super unless @limit_cutoff # super for the last page

        # Disable the LIMIT because it is replaced by the LIMIT filter.
        # That keeps the fetching accurate also when records are added or removed from a page alredy visited
        @more = true
        @set.limit(nil).to_a
      end

      # If @limit_cutoff: generate a filter between cutoffs
      # and use the LIMIT filter as a repacement of the SQL LIMIT.
      def filter_records_sql
        return super unless @limit_cutoff # super for the last page

        # Generate a composite filter between:
        #   - The beginning of the set and the @limit_cutoff if page == 1
        #     Filter logic: NOT BEYOND_LIMIT_CUTOFF
        #   - The current cutoff and the @limit_cutoff if page > 1
        #     Filter logic: BEYOND_CUTOFF AND NOT BEYOND_LIMIT_CUTOFF
        sql = +''
        # Generate the CUTOFF filter unless @page == 1 that doesn't have a cutoff
        sql << "(#{super}) AND " if @cutoff
        # Add the LIMIT filter, passing the prefix for the placeholdars
        sql << "NOT (#{super(LIMIT_PREFIX)})"
      end

      # Return the next page number, and cache the next cutoff if it's missing from the cache (only last page)
      def next
        records
        return if !@more || (@vars[:max_pages] && @page >= @vars[:max_pages])

        @next ||= (@page + 1).tap do |next_page|
                    @cutoffs[next_page] = generate_next_cutoff unless @limit_cutoff
                  end
      end

      # Set up the cache and check for OverflowError.
      def setup_cache
        raise VariableError.new(self, :cache, 'to be a Hash-like object', @vars[:cache]) \
              unless @vars[:cache].respond_to?(:[]=) && @vars[:cache].respond_to?(:[])

        key = @vars[:cache_key].is_a?(Proc) ? @vars[:cache_key].(@vars) : @vars[:cache_key]
        raise VariableError.new(self, :cache_key, 'to be a String or a Proc returning a string', key) \
              unless key.is_a?(String) && !key.empty?

        @cutoffs = @vars[:cache][key] ||= [nil, nil]  # nil-0: 1-based array; nil-1: first page cutoff is nil
        last     = @cutoffs.size - 1 # at this point it's not the @last for the UI (see initializer)
        raise OverflowError.new(self, :page, "in 1..#{last}", @page) if @page > last
      end
    end
  end
end
