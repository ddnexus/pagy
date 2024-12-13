# See Pagy::Countless API documentation: https://ddnexus.github.io/pagy/docs/api/keyset/numeric
# frozen_string_literal: true

require_relative '../keyset'

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
      CUTOFF_PREFIX = 'cutoff_'  # Prefix for cut_args

      include SharedNumericMethods
      attr_reader :cuts

      # Finalize the instance variables needed for the UI
      def initialize(set, **vars)
        super
        # Ensure next is called, so the last page used by the UI helpers is known
        self.next
        @prev = @page - 1 unless @page == 1
        @last = @cuts.size - 1 # 1-based array size
        @in   = @records.size
      end

      # Get the cut from the cache
      def assign_cuts
        @cuts = @vars[:cuts] || [nil, nil]
        pages = @cuts.size - 1
        if @page > pages
          raise OverflowError.new(self, :page, "in 1..#{pages}", @page) unless @vars[:reset_overflow]

          @page = 1
          @cuts = [nil, nil]
        end
        @prev_cut = @cuts[@page]     # nil for page 1 (i.e. begins from begin of set)
        @next_cut = @cuts[@page + 1] # known page; nil for last page
      end

      # Assign different args to support the AFTER_NEXT_CUT SQL if @next_cut
      def assign_cut_args
        return super unless @next_cut

        @cut_args = cut_to_args(@prev_cut) if @prev_cut
        # The next_cut args are preserved by prefixing them before merging
        next_args = cut_to_args(@next_cut).transform_keys { |key| :"#{CUTOFF_PREFIX}#{key}" }
        (@cut_args ||= {}).merge!(next_args)
      end

      # Assign a numeric page
      def assign_page
        assign_and_check(page: 1)
      end

      # Prepare the literal SQL string (complete with the placeholders for value interpolation)
      # used to filter the page records if @next_cut; super otherwise.
      #
      # If @next_cut there are two scenarios, depending on the page number:
      #
      # 1. If page == 1
      #    Pull the inital records and filter them out after the @next_cut
      #    SQL logic: NOT AFTER NEXT_CUT
      #
      # 2. If page > 1
      #    Pull the records BETWEEN the @prev_cut and the @next_cut
      #    SQL logic: AFTER PREV_CUT AND NOT AFTER NEXT_CUT
      #
      # The AFTER PREV_CUT SQL is like the regular keyset SQL (calling super). For example:
      # With a set like Pet.order(animal: :asc, name: :desc, id: :asc) it returns the following string:
      #
      #    ("pets"."animal" = :animal AND "pets"."name" = :name AND "pets"."id" > :id) OR
      #    ("pets"."animal" = :animal AND "pets"."name" < :name) OR
      #    ("pets"."animal" > :animal)
      #
      # Notice that the placeholders are not prefixed
      #
      # The AFTER NEXT_CUT SQL is used as a repacement of the SQL LIMIT.
      # That ensures accuracy in case of records added or removed
      # Here is how an AFTER NEXT_CUT looks for the same set:
      #
      #    ("pets"."animal" = :limit_animal AND "pets"."name" = :limit_name AND "pets"."id" > :limit_id) OR
      #    ("pets"."animal" = :limit_animal AND "pets"."name" < :limit_name) OR
      #    ("pets"."animal" > :limit_animal)
      #
      # Notice that the placeholders are prefixed by ":next_" which matches with the arguments prefixed keys
      def after_cut_sql
        return super unless @next_cut # super for the last known page

        sql = +''
        # Generate the AFTER PREV_CUT SQL unless @page == 1 (which starts from the fist record in the set)
        sql << "(#{super}) AND " if @prev_cut
        # Add the AFTER NEXT_CUT SQL, passing the prefix for the placeholdars
        sql << "NOT (#{super(CUTOFF_PREFIX)})"
      end

      # Add the default variables required by the Frontend
      def default
        { **super, **DEFAULT.slice(:ends, :page, :size, :cache_key_param) }
      end

      # Remove the LIMIT if @next_cut
      def fetch_records
        return super unless @next_cut # super for the last known page

        # Disable the LIMIT because it is replaced by the AFTER NEXT_CUT SQL.
        # That keeps the fetching accurate also when records are added or removed from a page alredy visited
        @more = true
        @set.limit(nil).to_a
      end

      # Return the next page number, and cache the next_cut if it's missing from the cache (only last known page)
      def next
        records
        return if !@more || (@vars[:max_pages] && @page >= @vars[:max_pages])

        @next ||= (@page + 1).tap do |next_page|
                    @cuts[next_page] = derive_next_cut unless @next_cut
                  end
      end
    end
  end
end
