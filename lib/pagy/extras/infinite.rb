# frozen_string_literal: true

# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/infinite

require 'pagy/extras/shared'

class Pagy
  module Backend ; private         # the whole module is private so no problem with including it in a controller

    # Return Pagy object and items
    def pagy_infinite(collection, vars={})
      pagy = Pagy.new(pagy_infinite_get_vars(collection, vars))
      return pagy, pagy_get_items(collection, pagy)
    end

    # Sub-method called only by #pagy: here for easy customization of variables by overriding
    def  pagy_infinite_get_vars(collection, vars)
      current_page = vars[:page] || (params[vars[:page_param] || Pagy::VARS[:page_param]] || 1).to_i
      per_page_items = vars[:items] || Pagy::VARS[:items]
      infinite_count = current_page * per_page_items
      if collection.limit(per_page_items).offset(infinite_count).exists?
        infinite_count += 1
      end

      # Return the merged variables to initialize the Pagy object
      {
        size: [],
        count: infinite_count,
        page: current_page,
      }.merge!(vars)
    end

  end
end

