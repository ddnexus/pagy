# frozen_string_literal: true

require_relative '../core/seriable'

class Pagy
  class Keyset
    # Use keyset pagination with support for all the frontend helpers
    class Keynav < Keyset
      autoload :ActiveRecord, PAGY_PATH.join('keyset/keynav/active_record')
      autoload :Sequel,       PAGY_PATH.join('keyset/keynav/sequel')

      include Core::Seriable

      # Avoid conflicts between filter arguments in composite SQL fragments
      PRIOR_PREFIX = 'prior_'
      PAGE_PREFIX  = 'page_'

      attr_reader :update

      # Finalize the instance variables needed for the UI
      def initialize(set, **)
        super
        # Ensure next is called, so the last page used by the UI helpers is known
        self.next
        @previous = @page - 1 unless @page == 1
        @in       = @records.size
      end

      # Support skipping the LIMIT if the page has already been visited
      def assign_filter
        return super unless @page_cutoff

        @filter = filter_for(@prior_cutoff, PRIOR_PREFIX) if @prior_cutoff
        (@filter ||= {}).merge!(filter_for(@page_cutoff, PAGE_PREFIX))
      end

      # Get the keynav page from the client
      def assign_page
        if @options[:page]
          storage_key, @page, @last, @prior_cutoff, @page_cutoff = @options[:page]
        else
          @page = @last = 1
        end
        @update = [storage_key, @options[:page_sym]]
      end

      # Remove the LIMIT if the page has already been visited
      def fetch_records
        return super unless @page_cutoff # last known page

        @more = true
        @set.limit(nil).to_a
      end

      # Prepare the @update for the client when it's a new page and return the next page number
      def next
        records
        return if !@more || (@options[:max_pages] && @page >= @options[:max_pages])

        @next ||= begin
                    unless @page_cutoff
                      @page_cutoff = derive_cutoff
                      @last       += 1                                # reflect the added cutoff
                      @update.push(@last, [@page, 1, @page_cutoff])   # last + splice arguments for the client cutoffs
                    end
                    @page + 1
                  end
      end

      # Generate an accurate composite filter that does not need LIMIT
      # if the page has already been visited
      def sql_filter
        return super unless @page_cutoff # last known page

        sql = +''
        # Include the records after @prior_cutoff (if any)
        sql << "(#{super(PRIOR_PREFIX)}) AND " if @prior_cutoff
        # Exclude the records after @page_cutoff
        sql << "NOT (#{super(PAGE_PREFIX)})"
      end

      def keynav? = true
    end
  end
end
