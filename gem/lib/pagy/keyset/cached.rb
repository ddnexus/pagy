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
      ON_PREFIX  = 'on_'   # Prefix for ON filter query_params
      OFF_PREFIX = 'off_'  # Prefix for OFF filter query_params

      include SharedMethodsForUI

      # Finalize the instance variables needed for the UI
      def initialize(set, **vars)
        super
        # Ensure next is called, so the last page used by the UI helpers is known
        self.next
        @prev = @page - 1 unless @page == 1
        @last = @cursors.size - 1 # 1-based array size
        @in   = @records.size
      end

      # Get the cursor from the cache
      def assign_cursor
        @cursor = @cursors[@page]
      end

      # Assign a numeric page param
      def assign_page
        assign_and_check(page: 1)
      end

      # Assign the query_params and define the :on and :off filter flags referring to
      # the SQL conditions of the filter_record_query, i.e. the page record selected
      # are included between the :on and :off filters
      #
      # The ON flag indicates that the filter query contains a SQL statement identifying where
      # the page records bregins. It is missing for page 1 (which starts from the first record).
      #
      # The OFF flag indicates that the filter query contains a SQL statement identifying where
      # the page records ends. It is present when there is a cached cursor pointing to the last page record.
      # That is used as a repacement of the LIMIT, which may become inaccurate for cached cursors.
      def assign_query_params
        @filter = {}
        if @cursor
          @query_params = cursor_to_query_params(@cursor, ON_PREFIX)
          @filter[:on]  = true # the filter is ON after the record identified by the cursor
        end
        if (next_cursor = @cursors[@page + 1])
          params = cursor_to_query_params(next_cursor, OFF_PREFIX)
          (@query_params ||= {}).merge!(params)
          @filter[:off]    = true # the filter is OFF after the record identified by the next_cursor
        end
      end

      # Add the default variables required by the UI
      def default
        { **super, **DEFAULT.slice(:ends, :page, :size) }
      end

      # Get the records and set the @more (different way for cached next_cursor)
      def fetch_records
        # When a cached next_cursor is present, use it to replace the LIMIT with an OFF filter condition
        # That keeps the fetching accurate also when records are added or removed from a page alredy visited
        if @filter[:off]
          @more = true
          @set.limit(nil).to_a
        else
          super
        end
      end

      # Generate a single ON_FILTER if there is no cached next_cursor (execute with LIMIT)
      # Generate a composite filter with ON_FILTER AND NOT OFF_FILTER if there is a cached next_cursor (execute without LIMIT)
      def filter_records_query
        sql = +''
        sql << "(#{super(ON_PREFIX)})" if @filter[:on]
        if @filter[:off]
          sql << ' AND ' if @filter[:on]
          sql << "NOT (#{super(OFF_PREFIX)})"
        end
        sql
      end

      # Return the next page number and cache the next_cursor if it's missing
      def next
        records
        return if !@more || (@vars[:max_pages] && @page >= @vars[:max_pages])

        @next ||= (@page + 1).tap do |next_page|
                    @cursors[next_page] ||= next_cursor unless @filter[:off]  # only for non cached next_cursor
                  end
      end

      # Set up the cache and check for OverflowError.
      def setup_cache
        raise VariableError.new(self, :cache, 'to be a Hash-like object', @vars[:cache]) \
              unless @vars[:cache].respond_to?(:[]=) && @vars[:cache].respond_to?(:[])

        key = @vars[:cache_key].is_a?(Proc) ? @vars[:cache_key].(@vars) : @vars[:cache_key]
        raise VariableError.new(self, :cache_key, 'to be a String or a Proc returning a string', key) \
              unless key.is_a?(String) && !key.empty?

        @cursors = @vars[:cache][key] ||= [nil, nil]  # nil: 1-based array; nil: first cursor is nil
        last     = @cursors.size - 1 # at this point it's not the @last for the UI (see initislizer)
        raise OverflowError.new(self, :page, "in 1..#{last}", @page) if @page > last
      end
    end
  end
end
