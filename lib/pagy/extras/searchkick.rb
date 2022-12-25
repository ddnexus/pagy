# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/searchkick
# frozen_string_literal: true

class Pagy # :nodoc:
  DEFAULT[:searchkick_search]      ||= :search
  DEFAULT[:searchkick_pagy_search] ||= :pagy_search

  # Paginate Searchkick::Results objects
  module SearchkickExtra
    module Searchkick # :nodoc:
      # Return an array used to delay the call of #search
      # after the pagination variables are merged to the options.
      # It also pushes to the same array an optional method call.
      def pagy_searchkick(term = '*', **options, &block)
        [self, term, options, block].tap do |args|
          args.define_singleton_method(:method_missing) { |*a| args += a }
        end
      end
      alias_method Pagy::DEFAULT[:searchkick_pagy_search], :pagy_searchkick
    end

    # Additions for the Pagy class
    module Pagy
      # Create a Pagy object from a Searchkick::Results object
      def new_from_searchkick(results, vars = {})
        vars[:items] = results.options[:per_page]
        vars[:page]  = results.options[:page]
        vars[:count] = results.total_count
        new(vars)
      end
    end

    # Add specialized backend methods to paginate Searchkick::Results
    module Backend
      private

      # Return Pagy object and results
      def pagy_searchkick(pagy_search_args, vars = {})
        model, term, options, block, *called = pagy_search_args
        vars               = pagy_searchkick_get_vars(nil, vars)
        options[:per_page] = vars[:items]
        options[:page]     = vars[:page]
        results            = model.send(DEFAULT[:searchkick_search], term, **options, &block)
        vars[:count]       = results.total_count

        pagy = ::Pagy.new(vars)
        # with :last_page overflow we need to re-run the method in order to get the hits
        return pagy_searchkick(pagy_search_args, vars.merge(page: pagy.page)) \
               if defined?(::Pagy::OverflowExtra) && pagy.overflow? && pagy.vars[:overflow] == :last_page

        [pagy, called.empty? ? results : results.send(*called)]
      end

      # Sub-method called only by #pagy_searchkick: here for easy customization of variables by overriding
      # the _collection argument is not available when the method is called
      def pagy_searchkick_get_vars(_collection, vars)
        pagy_set_items_from_params(vars) if defined?(ItemsExtra)
        vars[:items] ||= DEFAULT[:items]
        vars[:page]  ||= (params[vars[:page_param] || DEFAULT[:page_param]] || 1).to_i
        vars
      end
    end
  end
  Searchkick = SearchkickExtra::Searchkick
  extend SearchkickExtra::Pagy
  Backend.prepend SearchkickExtra::Backend
end
