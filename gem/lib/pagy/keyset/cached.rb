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
      ON_PREFIX  = 'on_'   # Prefix for ON filter filter_params
      OFF_PREFIX = 'off_'  # Prefix for OFF filter filter_params

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

      # Assign a numeric page param
      def assign_page
        assign_and_check(page: 1)
      end

      # Assign the filter_params and define the :on and :off filter flags referring to
      # the SQL conditions of the filter_record_query, i.e. the page record selected
      # are included between the :on and :off filters
      #
      # The ON flag indicates that the filter query contains a SQL statement identifying where
      # the page records bregin. It is missing for page 1 (which starts from the first record).
      #
      # The OFF flag indicates that the filter query contains a SQL statement identifying where
      # the page records end. It is present when there is a cached cutoff pointing to the last page record.
      # That is used as a repacement of the LIMIT, which may become inaccurate for cached cutoffs.
      def assign_filter_params
        @filter = {}
        if @cutoff
          @filter_params = cutoff_to_filter_params(@cutoff, ON_PREFIX)
          @filter[:on]   = true # the filter is ON beyond the cutoff
        end
        if (next_cutoff = @cutoffs[@page + 1])
          filter_params     = cutoff_to_filter_params(next_cutoff, OFF_PREFIX)
          (@filter_params ||= {}).merge!(filter_params)
          @filter[:off]     = true # the filter is OFF beyond the next_cutoff
        end
      end

      # Add the default variables required by the UI
      def default
        { **super, **DEFAULT.slice(:ends, :page, :size) }
      end

      # Get the records and set the @more (different way for cached next_cutoff)
      def fetch_records
        # When a cached next_cutoff is present, use it to replace the LIMIT with an OFF filter condition
        # That keeps the fetching accurate also when records are added or removed from a page alredy visited
        if @filter[:off]
          @more = true
          @set.limit(nil).to_a
        else
          super
        end
      end

      # Generate a single ON_FILTER if there is no cached next_cutoff (execute with LIMIT)
      # Generate a composite filter with ON_FILTER AND NOT OFF_FILTER if there is a cached next_cutoff (execute without LIMIT)
      def filter_records_query
        sql = +''
        sql << "(#{super(ON_PREFIX)})" if @filter[:on]
        if @filter[:off]
          sql << ' AND ' if @filter[:on]
          sql << "NOT (#{super(OFF_PREFIX)})"
        end
        sql
      end

      # Return the next page number and cache the next_cutoff if it's missing
      def next
        records
        return if !@more || (@vars[:max_pages] && @page >= @vars[:max_pages])

        @next ||= (@page + 1).tap do |next_page|
                    @cutoffs[next_page] ||= next_cutoff unless @filter[:off]  # only for non cached next_cutoff
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
