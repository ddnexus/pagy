# See Pagy::Countless API documentation: https://ddnexus.github.io/pagy/docs/api/keyset_for_ui
# frozen_string_literal: true

require_relative 'keyset'

class Pagy # :nodoc:
  # Use keyset pagination with numeric pages
  # supporting pagy_nav and other frontend helpers.
  class KeysetForUI < Keyset
    class ActiveRecord < KeysetForUI
      include ActiveRecordAdapter
    end

    class Sequel < KeysetForUI
      include SequelAdapter
    end

    # Avoid args conflicts in composite SQL fragments
    CUTOFF_PREFIX = 'cutoff_' # Prefix for cutoff_args

    include SharedUIMethods
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
    def assign_cutoffs
      @cutoffs     = @vars[:cutoffs] || [nil, nil]
      pages        = @cutoffs.size - 1
      if @page > pages
        raise OverflowError.new(self, :page, "in 1..#{pages}", @page) unless @vars[:reset_overflow]

        @page    = 1
        @cutoffs = [nil, nil]
      end
      @prev_cutoff = @cutoffs[@page] # nil for page 1 (i.e. begins from begin of set)
      @cutoff      = @cutoffs[@page + 1] # known page; nil for last page
    end

    # Assign different args to support the AFTER_CUTOFF SQL if @cutoff
    def assign_cutoff_args
      return super unless @cutoff

      @cutoff_args = cutoff_to_args(@prev_cutoff) if @prev_cutoff
      # The cutoff args are preserved by prefixing them before merging
      next_args = cutoff_to_args(@cutoff).transform_keys { |key| :"#{CUTOFF_PREFIX}#{key}" }
      (@cutoff_args ||= {}).merge!(next_args)
    end

    # Assign a numeric page
    def assign_page
      assign_and_check(page: 1)
    end

    # Prepare the literal SQL string (complete with the placeholders for value interpolation)
    # used to filter the page records if @cutoff; super otherwise.
    #
    # If @cutoff there are two scenarios, depending on the page number:
    #
    # 1. If page == 1
    #    Pull the inital records and filter them out after the @cutoff
    #    SQL logic: NOT AFTER CUTOFF
    #
    # 2. If page > 1
    #    Pull the records BETWEEN the @prev_cutoff and the @cutoff
    #    SQL logic: AFTER PREV_CUTOFF AND NOT AFTER CUTOFF
    #
    # The AFTER PREV_CUTOFF SQL is like the regular keyset SQL (calling super). For example:
    # With a set like Pet.order(animal: :asc, name: :desc, id: :asc) it returns the following string:
    #
    #    ("pets"."animal" = :animal AND "pets"."name" = :name AND "pets"."id" > :id) OR
    #    ("pets"."animal" = :animal AND "pets"."name" < :name) OR
    #    ("pets"."animal" > :animal)
    #
    # Notice that the placeholders are not prefixed
    #
    # The AFTER CUTOFF SQL is used as a repacement of the SQL LIMIT.
    # That ensures accuracy in case of records added or removed
    # Here is how an AFTER CUTOFF looks for the same set:
    #
    #    ("pets"."animal" = :cutoff_animal AND "pets"."name" = :cutoff_name AND "pets"."id" > :cutoff_id) OR
    #    ("pets"."animal" = :cutoff_animal AND "pets"."name" < :cutoff_name) OR
    #    ("pets"."animal" > :cutoff_animal)
    #
    # Notice that the placeholders are prefixed by ":next_" which matches with the arguments prefixed keys
    def after_cutoff_sql
      return super unless @cutoff # super for the last known page

      sql = +''
      # Generate the AFTER PREV_CUTOFF SQL unless @page == 1 (which starts from the fist record in the set)
      sql << "(#{super}) AND " if @prev_cutoff
      # Add the AFTER CUTOFF SQL, passing the prefix for the placeholdars
      sql << "NOT (#{super(CUTOFF_PREFIX)})"
    end

    # Add the default variables required by the Frontend
    def default
      { **super, **DEFAULT.slice(:ends, :page, :size, :cache_key_param) }
    end

    # Remove the LIMIT if @cutoff
    def fetch_records
      return super unless @cutoff # super for the last known page

      # Disable the LIMIT because it is replaced by the AFTER CUTOFF SQL.
      # That keeps the fetching accurate also when records are added or removed from a page alredy visited
      @more = true
      @set.limit(nil).to_a
    end

    # Return the next page number, and cache the cutoff if it's missing from the cache (only last known page)
    def next
      records
      return if !@more || (@vars[:max_pages] && @page >= @vars[:max_pages])

      @next ||= (@page + 1).tap do |next_page|
        @cutoffs[next_page] = derive_cutoff unless @cutoff
      end
    end
  end
end
