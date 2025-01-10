# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/searchkick
# frozen_string_literal: true

require_relative '../offset/searchkick'

class Pagy
  # Model extension
  module Searchkick
    # Return an array used to delay the call of #search
    # after the pagination variables are merged to the options.
    # It also pushes to the same array an optional method call.
    def pagy_searchkick(term = '*', **options, &block)
      [self, term, options, block].tap do |args|
        args.define_singleton_method(:method_missing) { |*a| args += a }
      end
    end
    alias_method Offset::Searchkick::DEFAULT[:searchkick_pagy_search], :pagy_searchkick
  end

  # Add specialized backend methods to paginate Searchkick::Results
  Backend.class_eval do
    private

    # Return Pagy object and results
    def pagy_searchkick(pagy_search_args, **vars)
      vars[:page]  ||= pagy_get_page(vars)
      vars[:limit] ||= pagy_get_limit(vars)
      model, term, options, block, *called = pagy_search_args
      options[:per_page] = vars[:limit]
      options[:page]     = vars[:page]
      results            = model.send(Offset::Searchkick::DEFAULT[:searchkick_search], term, **options, &block)
      vars[:count]       = results.total_count
      pagy               = Offset::Searchkick.new(**vars)
      # with :last_page overflow we need to re-run the method in order to get the hits
      if pagy.overflow? && pagy.vars[:overflow] == :last_page      # rubocop:disable Style/IfUnlessModifier
        return pagy_searchkick(pagy_search_args, **vars, page: pagy.page)
      end

      [pagy, called.empty? ? results : results.send(*called)]
    end
  end
end
