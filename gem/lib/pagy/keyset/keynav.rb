# frozen_string_literal: true

require_relative '../support/features/seriable'

class Pagy
  class Keyset
    # Use keyset pagination with support for all the frontend helpers
    class Keynav < Keyset
      # Avoid conflicts between filter arguments in composite SQL fragments
      PRIOR_PREFIX = 'prior_'
      PAGE_PREFIX  = 'page_'

      autoload :ActiveRecord, PAGY_PATH.join('keyset/keynav/active_record')
      autoload :Sequel,       PAGY_PATH.join('keyset/keynav/sequel')

      include Seriable

      # Finalize the instance variables needed for the UI
      def initialize(set, **)
        super
        # Ensure next is called, so the last page used by the UI helpers is known
        self.next
        @previous = @page - 1 unless @page == 1
        @in       = @records.size
      end

      attr_reader :update

      def keynav? = true

      # Prepare the @update for the client when it's a new page, and return the next page number
      def next
        records
        return if !@more || (@options[:max_pages] && @page >= @options[:max_pages])

        @next ||= begin
                    unless @page_cutoff
                      @page_cutoff = extract_cutoff
                      @last       += 1                                # reflect the added cutoff
                      @update.push(@last, [@page, 1, @page_cutoff])   # last + splice arguments for the client cutoffs
                    end
                    @page + 1
                  end
      end

      protected

      # Process the page array
      def assign_page
        if @options[:page]
          storage_key, @page, @last, @prior_cutoff, @page_cutoff = @options[:page]
        else
          @page = @last = 1
        end
        @update = [storage_key, @options[:page_sym]]
      end

      # Use a compound predicate to fetch the records
      def fetch_records
        return super unless @page_cutoff # last page

        # Compound predicate for visited pages
        predicate = +''
        arguments = {}
        if @prior_cutoff # not the first page
          # Include the records after @prior_cutoff
          predicate << "(#{compose_predicate(PRIOR_PREFIX)}) AND "
          arguments.merge!(arguments_from(@prior_cutoff, PRIOR_PREFIX))
        end
        # Exclude the records after @page_cutoff
        predicate << "NOT (#{compose_predicate(PAGE_PREFIX)})"
        arguments.merge!(arguments_from(@page_cutoff, PAGE_PREFIX))
        apply_where(predicate, arguments)

        @more = true          # not the last page
        @set.limit(nil).to_a  # replaced by the compound predicate
      end
    end
  end
end
