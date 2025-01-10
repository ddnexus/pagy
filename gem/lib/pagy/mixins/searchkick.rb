# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/searchkick
# frozen_string_literal: true

require_relative '../offset'

class Pagy
  Offset::DEFAULT[:searchkick_search]      ||= :search
  Offset::DEFAULT[:searchkick_pagy_search] ||= :pagy_search

  # Paginate Searchkick::Results objects
  module SearchkickMixin
    module ModelExtension # :nodoc:
      # Return an array used to delay the call of #search
      # after the pagination variables are merged to the options.
      # It also pushes to the same array an optional method call.
      def pagy_searchkick(term = '*', **options, &block)
        [self, term, options, block].tap do |args|
          args.define_singleton_method(:method_missing) { |*a| args += a }
        end
      end
      alias_method Offset::DEFAULT[:searchkick_pagy_search], :pagy_searchkick
    end
    Pagy::Searchkick = ModelExtension

    # Addition for the Pagy::Offset class (requires an instance_eval to override the loader alias)
    Offset.instance_eval do
      # Create a Pagy::Offset object from a Searchkick::Results object
      def new_from_searchkick(results, **vars)
        vars[:limit] = results.options[:per_page]
        vars[:page]  = results.options[:page]
        vars[:count] = results.total_count
        new(**vars)
      end
    end

    # Add specialized backend methods to paginate Searchkick::Results
    module BackendAddOn
      private

      # Return Pagy object and results
      def pagy_searchkick(pagy_search_args, **vars)
        vars[:page]  ||= pagy_get_page(vars)
        vars[:limit] ||= pagy_get_limit(vars)
        model, term, options, block, *called = pagy_search_args
        options[:per_page] = vars[:limit]
        options[:page]     = vars[:page]
        results            = model.send(Offset::DEFAULT[:searchkick_search], term, **options, &block)
        vars[:count]       = results.total_count

        pagy = Offset.new(**vars)
        # with :last_page overflow we need to re-run the method in order to get the hits
        return pagy_searchkick(pagy_search_args, **vars, page: pagy.page) \
               if pagy.overflow? && pagy.vars[:overflow] == :last_page

        [pagy, called.empty? ? results : results.send(*called)]
      end
    end
    Backend.prepend BackendAddOn
  end
end
