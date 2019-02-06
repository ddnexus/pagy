# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/searchkick
# encoding: utf-8
# frozen_string_literal: true

class Pagy
  # Add specialized backend methods to paginate Searchkick::Results
  module Backend ; private
    # Return Pagy object and items
    def pagy_searchkick(results, vars={})
      pagy = Pagy.new(pagy_searchkick_get_vars(results, vars))
      return pagy, results
    end

    # Sub-method called only by #pagy_searchkick: here for easy customization of variables by overriding
    def pagy_searchkick_get_vars(results, vars)
      vars[:count] ||= results.total_count
      vars[:page]  ||= results.options[:page]
      vars[:items] ||= results.options[:per_page]
      vars
    end
  end
end
