# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/searchkick
# encoding: utf-8
# frozen_string_literal: true

require 'pagy/extras/pagy_search'

class Pagy

  # used by the items extra
  SEARCHKICK = true

  # create a Pagy object from a Searchkick::Results object
  def self.new_from_searchkick(results, vars={})
    vars[:items] = results.options[:per_page]
    vars[:page]  = results.options[:page]
    vars[:count] = results.total_count
    new(vars)
  end

  # Add specialized backend methods to paginate Searchkick::Results
  module Backend ; private

    # Return Pagy object and results
    def pagy_searchkick(pagy_search_args, vars={})
      model, search_args, block, *called = pagy_search_args
      vars                       = pagy_searchkick_get_vars(nil, vars)
      search_args[-1][:per_page] = vars[:items]
      search_args[-1][:page]     = vars[:page]
      results                    = pagy_searchkick_get_results(model, search_args, block)
      vars[:count]               = results.total_count
      pagy = Pagy.new(vars)
      # with :last_page overflow we need to re-run the method in order to get the hits
      if defined?(OVERFLOW) && pagy.overflow? && pagy.vars[:overflow] == :last_page
        return pagy_searchkick(pagy_search_args, vars.merge(page: pagy.page))
      end
      return pagy, called.empty? ? results : results.send(*called)
    end

    # Sub-method called only by #pagy_searchkick: here for easy customization of variables by overriding
    # the _collection argument is not available when the method is called
    def pagy_searchkick_get_vars(_collection, vars)
      vars[:items] ||= VARS[:items]
      vars[:page]  ||= (params[ vars[:page_param] || VARS[:page_param] ] || 1).to_i
      vars
    end

    if RUBY_VERSION.start_with?('3.')
      eval <<-RUBY
        def pagy_searchkick_get_results(model, search_args, block)
          options = search_args.pop
          model.search(*search_args, **options, &block)
        end
      RUBY
    else
      def pagy_searchkick_get_results(model, search_args, block)
        model.search(*search_args, &block)
      end
    end

  end
end
