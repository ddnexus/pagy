# See Pagy::Countless API documentation: https://ddnexus.github.io/pagy/docs/api/keyset/numeric
# frozen_string_literal: true

require_relative '../keyset'
require 'digest/sha2'

class Pagy # :nodoc:
  class Keyset
    # Use keyset pagination with numeric pages
    # supporting pagy_nav and other frontend helpers.
    class Numeric < Keyset
      class ActiveRecord < Numeric
        include ActiveRecordAdapter
      end

      class Sequel < Numeric
        include SequelAdapter
      end
      # Avoid args conflicts in composite SQL fragments
      LIMIT_PREFIX = 'limit_'  # Prefix for cutoff_args

      include SharedNumericMethods
      attr_reader :cutoffs

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
        @cutoffs = @vars[:cutoffs] || [nil, nil]
        pages    = @cutoffs.size - 1
        if @page > pages
          raise OverflowError.new(self, :page, "in 1..#{pages}", @page) unless @vars[:reset_overflow]

          @page    = 1
          @cutoffs = [nil, nil]
        end
        @cutoff = @cutoffs[@page]
      end

      # Assign different args to support the BEYOND_LIMIT_CUTOFF SQL if @limit_cutoff
      def assign_cutoff_args
        # @limit_cutoff is the cached cutoff for the next page:
        # the curent page has been visited, hence it's not the last
        return super unless @limit_cutoff ||= @cutoffs[@page + 1] # return super only when it's the last page

        # The regular cutoff args are missing for page 1 (which doesn't have a cutoff).
        @cutoff_args = cutoff_to_args(@cutoff) if @cutoff

        # The limit_cutoff args are preserved by prefixing them before merging
        limit_cutoff_args = cutoff_to_args(@limit_cutoff).transform_keys { |key| :"#{LIMIT_PREFIX}#{key}" }
        (@cutoff_args   ||= {}).merge!(limit_cutoff_args)
      end

      # Assign a numeric page
      def assign_page
        assign_and_check(page: 1)
      end

      # Prepare the literal SQL string (complete with the placeholders for value interpolation)
      # used to filter the page records if @limit_cutoff; super otherwise.
      #
      # If @limit_cutoff there are two scenarios, depending on the page number:
      #
      # 1. If page == 1
      #    Pull the inital records till the @limit_cutoff
      #    SQL logic: NOT BEYOND_LIMIT_CUTOFF
      #
      # 2. If page > 1
      #    Pull the records BETWEEN the current @cutoff and the @limit_cutoff
      #    SQL logic: BEYOND_CUTOFF AND NOT BEYOND_LIMIT_CUTOFF
      #
      # The BEYOND_CUTOFF SQL is like the regular keyset SQL (calling super). For example:
      # With a set like Pet.order(animal: :asc, name: :desc, id: :asc) it returns the following string:
      #
      #    ("pets"."animal" = :animal AND "pets"."name" = :name AND "pets"."id" > :id) OR
      #    ("pets"."animal" = :animal AND "pets"."name" < :name) OR
      #    ("pets"."animal" > :animal)
      #
      # The BEYOND_LIMIT_CUTOFF SQL is used as a repacement of the SQL LIMIT.
      # That ensures accuracy in case of records added or removed
      # Here is how a BEYOND_LIMIT_CUTOFF looks for the same set:
      #
      #    ("pets"."animal" = :limit_animal AND "pets"."name" = :limit_name AND "pets"."id" > :limit_id) OR
      #    ("pets"."animal" = :limit_animal AND "pets"."name" < :limit_name) OR
      #    ("pets"."animal" > :limit_animal)
      #
      # Notice that the :limit_* placeholder will be replaced with the arguments
      # of the next cutoff (beyond which the records belong to another page)
      def beyond_cutoff_sql
        return super unless @limit_cutoff # super for the last page

        sql = +''
        # Generate the BEYOND_CUTOFF SQL unless @page == 1 that doesn't have a cutoff
        sql << "(#{super}) AND " if @cutoff
        # Add the BEYOND_LIMIT_CUTOFF SQL, passing the prefix for the placeholdars
        sql << "NOT (#{super(LIMIT_PREFIX)})"
      end

      # Add the default variables required by the Frontend
      def default
        { **super, **DEFAULT.slice(:ends, :page, :size, :cache_key_param) }
      end

      # Remove the LIMIT if @limit_cutoff
      def fetch_records
        return super unless @limit_cutoff # super for the last page

        # Disable the LIMIT because it is replaced by the BEYOND_LIMIT_CUTOFF SQL.
        # That keeps the fetching accurate also when records are added or removed from a page alredy visited
        @more = true
        @set.limit(nil).to_a
      end

      # Return the next page number, and cache the next cutoff if it's missing from the cache (only last page)
      def next
        records
        return if !@more || (@vars[:max_pages] && @page >= @vars[:max_pages])

        @next ||= (@page + 1).tap do |next_page|
                    @cutoffs[next_page] = derive_cutoff unless @limit_cutoff
                  end
      end
    end
  end
end
