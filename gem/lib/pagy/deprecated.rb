# frozen_string_literal: true

# This file relegates all the deprecation warnings and code.
# Pagy already implements the next code and this file works as a compatibility layer
# to avoid breaking changes in the current version, respecting the Semantic Version contract.
class Pagy
  module Deprecated
    def self.client_max_limit(options)
      options[:client_limit] ||= options[:max_limit] || options[:client_max_limit]
      %i[max_limit client_max_limit].each do |key|
        warn "[PAGY] the #{key.inspect} option is deprecated: use :client_limit instead." if options.delete(key)
      end
    end

    module Pagy
      def assign_options(**options)
        if options.key?(:max_pages)
          warn '[PAGY] the :max_pages option is deprecated: ' \
               'use https://ddnexus.github.io/pagy/guides/how-to/#paginate-only-max-records instead.'
        end
        Deprecated.client_max_limit(options) # if used without Request#resolve_limit
        super
      end
    end

    ##### Enabled from the autoloaded class #####

    module Request  # :client_max_limit option
      def resolve_limit
        Deprecated.client_max_limit(@options)
        super
      end
    end

    module Offset
      def assign_last
        super
        @last = @options[:max_pages] if @options[:max_pages] && @last > @options[:max_pages]
      end
    end

    module Countless
      def initialize(**)
        super
        @page = upto_max_pages(@page)
        @last = upto_max_pages(@last) unless @options[:headless]
      end

      def finalize(fetched_size)
        super
        @last = upto_max_pages(@last)
      end

      def upto_max_pages(value)
        return value unless value && @options[:max_pages]

        [value, @options[:max_pages]].min
      end
    end

    module Keynav
      def next
        records
        super unless @options[:max_pages] && @page >= @options[:max_pages]
      end
    end
  end

  prepend Deprecated::Pagy

  # Reopen the module and add the deprecated methods
  module Configurable
    def options
      OPTIONS.tap do
        warn "[PAGY] 'Pagy.options' is deprecated: use 'Pagy::OPTIONS directly'"
      end
    end

    def sync_javascript(...)
      warn "[PAGY] 'Pagy.sync_javascript(...)' is deprecated: use 'Pagy.sync(:javascript, ...)' instead."
      sync(:javascript, ...)
    end
  end
end
