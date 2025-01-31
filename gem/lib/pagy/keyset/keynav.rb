# frozen_string_literal: true

require_relative '../core/seriable'

class Pagy
  class Keyset
    # Use keyset pagination with support for the pagy_*nav and other helpers.
    class Keynav < Keyset
      autoload :ActiveRecord, PAGY_PATH.join('keyset/keynav/active_record')
      autoload :Sequel,       PAGY_PATH.join('keyset/keynav/sequel')

      include Core::Seriable

      # Avoid filter args conflicts in composite SQL fragments
      CUTOFF_PREFIX = 'cutoff_'

      attr_reader :update

      # Finalize the instance variables needed for the UI
      def initialize(set, **)
        super
        # Ensure next is called, so the last page used by the UI helpers is known
        self.next
        @previous = @page - 1 unless @page == 1
        @in       = @records.size
      end

      # Assign different filter args to support the AFTER_CUTOFF SQL if @cutoff
      def assign_filter_args
        return super unless @cutoff

        # Don't prefix the usual filter args for the prev cutoff
        @filter_args = filter_args_for(@prev_cutoff) if @prev_cutoff
        # Preserve the cutoff args by prefixing them before merging
        cutoff_args = filter_args_for(@cutoff).transform_keys { |key| :"#{CUTOFF_PREFIX}#{key}" }
        (@filter_args ||= {}).merge!(cutoff_args)
      end

      # Get the keynav page from the client
      def assign_page
        if @options[:page]
          storage_key, @page, @last, @prev_cutoff, @cutoff = @options[:page]
        else
          @page = @last = 1
        end
        @update = [storage_key, @options[:page_sym]] # always sent back as-is in order to id the same pagination sequence
      end

      # Prepare the literal SQL string (complete with the placeholders for value interpolation)
      # used to filter the page records if the @cutoff is known.
      #
      # If the @cutoff is NOT known (i.e. @cutoff.nil?) it will call super
      # (i.e. the regular keyset business: AFTER PREV_CUTOFF + LIMIT SQL).
      #
      # If the @cutoff is known, the LIMIT is replaced with the NOT AFTER CUTOF SQL.
      # There are two scenarios about the page start, depending on the page number:
      #
      # 1. If page == 1
      #    Pull the inital records and filter them out after the @cutoff
      #    SQL logic: NOT AFTER CUTOFF
      #
      # 2. If page > 1
      #    Pull the records BETWEEN the @prev_cutoff and the @cutoff,
      #    (i.e. pull the records AFTER the @prev_cutoff and filter them out after the @cutoff)
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
      # Notice that the placeholders are prefixed by ":cutoff_" which matches with the arguments prefixed keys
      def after_cutoff_sql
        return super unless @cutoff # super for the last known page

        sql = +''
        # Generate the AFTER PREV_CUTOFF SQL unless @page == 1 (which starts from the fist record in the set)
        sql << "(#{super}) AND " if @prev_cutoff
        # Add the AFTER CUTOFF SQL, passing the prefix for the placeholdars
        sql << "NOT (#{super(CUTOFF_PREFIX)})"
      end

      # Remove the LIMIT if @cutoff
      def fetch_records
        return super unless @cutoff # super for the last known page

        # Disable the LIMIT because it is replaced by the AFTER CUTOFF SQL.
        # That keeps the fetching accurate also when records are added or removed from a page alredy visited
        @more = true
        @set.limit(nil).to_a
      end

      # Prepare the @update for the client when it's a new page/cutoff and return the next page number
      def next
        records
        return if !@more || (@options[:max_pages] && @page >= @options[:max_pages])

        @next ||= begin
                    unless @cutoff
                      @cutoff = derive_cutoff
                      @last  += 1                                # reflect the added cutoff
                      @update.push(@last, [@page, 1, @cutoff])   # splice arguments for the client cutoffs
                    end
                    @page + 1
                  end
      end

      def keynav? = true
    end
  end
end
