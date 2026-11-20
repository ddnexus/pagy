# frozen_string_literal: true

class Pagy
  class Keyset
    # Keyset pagination with broad UI support
    class Keynav < Keyset
      # Avoid conflicts between filter arguments in composite SQL fragments
      PRIOR_PREFIX = 'prior_'
      PAGE_PREFIX  = 'page_'
      # The delete count of the client splice and the increment of @last for each type of update
      SPLICE = { append: [1, 1],          # add the cutoff of the last page
                 split:  [0, 1],          # insert the cutoff of a grown page before its old cutoff
                 move:   [1, 0],          # replace the cutoff of the page
                 merge:  [1, -1] }.freeze # delete the cutoff of a short page that fits with the next page
      # The :reset update is calculated: it deletes all the cutoffs from the page on, and adds the cutoff of the page

      # Define empty subclasses to allow specific typing without triggering autoload
      class ActiveRecord < self; end
      class Sequel < self; end

      include NumericHelpers

      # Finalize the instance variables needed for the UI
      def initialize(set, **)
        super

        @previous = @page - 1 unless @page == 1
        @in       = @records.size
      end

      attr_reader :update, :previous, :last
      alias pages last

      # Prepare the @update for the client when its cutoffs must change, and return the next page number
      def next
        records
        @count = 0 if !@more && @page == 1  # empty records (trigger the right info message for known 0 count)
        update_cutoffs if @splice
        return unless @more

        @next ||= @page + 1
      end

      protected

      def keynav? = true

      # Process the page array, restarting from page 1 if it is missing or malformed
      def assign_page
        if valid_page?(*@options[:page])
          storage_key, @page, @last, @prior_cutoff, @page_cutoff, @next_cutoff = @options[:page]
          @guarded = @options[:page].size > 5 # the client sends the next cutoff and guards the updates
        else
          @page = @last = 1
        end

        @update = [storage_key, @options[:root_key], @options[:page_key]]
      end

      # Add the change of the page cutoff to the @update for the client: last + splice arguments + guard
      def update_cutoffs
        cutoffs           = @splice == :merge || !@more ? [] : [extract_cutoff]
        delete, increment = SPLICE[@splice] || [@last - @page, @page + cutoffs.size - @last] # :reset
        seen              = [@prior_cutoff, @page_cutoff, @next_cutoff] # the cutoffs sent by the client
        @page_cutoff      = @splice == :merge ? @next_cutoff : cutoffs.first
        @last            += increment
        @splice           = nil # update once
        @update.push(@last, [@page, delete, *cutoffs], seen)
      end

      # Check the page array coming from the client, which stores its cutoffs at the positions from 1 to last - 1:
      # each cutoff of the array (prior, page and next cutoff, if sent) must be present only at those positions
      def valid_page?(storage_key = nil, page = nil, last = nil, *cutoffs)
        storage_key.is_a?(String) && page.is_a?(Integer) && last.is_a?(Integer) && page.between?(1, last) &&
          cutoffs.all? { _1.nil? || (_1.is_a?(Array) && _1.size == @keyset.size) } &&
          (0...[cutoffs.size, 2].max).all? { cutoffs[_1].nil? != (page - 1 + _1).between?(1, last - 1) }
      end

      # Fetch the records between the cutoffs of the visited pages, rebalancing the pages that changed size
      def fetch_records
        return super.tap { @splice = :append if @more } unless @page_cutoff # last page

        set     = @set
        @more   = true # not the last page
        records = fetch_between(set, @prior_cutoff, @page_cutoff, @limit + 1)
        if records.size > @limit # page grown beyond the limit
          records.pop
          @splice = @guarded ? :split : :move
        elsif @guarded && records.size < @limit # short page
          room = @limit - records.size
          more = fetch_between(set, @page_cutoff, @next_cutoff, room + 1) # from the next page
          if @next_cutoff && records.empty? && more.empty? # two empty pages: restart as the last known page
            @set    = set
            @splice = :reset
            return super
          elsif more.size <= room # the next page fits
            records.concat(more)
            @splice = :merge
            @more   = !@next_cutoff.nil? # merged with the last page
          elsif @next_cutoff.nil? || records.empty? # fill from the last page, or skip the empty page
            more.pop
            records.concat(more)
            @splice = :move
          end
        end
        records
      end

      # Use a compound predicate to fetch the records after the prior cutoff, and not after the page cutoff
      def fetch_between(set, prior_cutoff, page_cutoff, limit)
        @set       = set
        predicates = []
        arguments  = {}

        if prior_cutoff # not the first page
          predicates << "(#{compose_predicate(PRIOR_PREFIX)})"
          arguments.merge!(arguments_from(prior_cutoff, PRIOR_PREFIX))
        end

        if page_cutoff # not the last page
          predicates << "NOT (#{compose_predicate(PAGE_PREFIX)})"
          arguments.merge!(arguments_from(page_cutoff, PAGE_PREFIX))
        end

        apply_where(predicates.join(' AND '), arguments)
        @set.limit(limit).to_a
      end

      prepend Deprecated::Keynav if defined?(Deprecated::Keynav)
    end
  end
end
