# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/countless
# frozen_string_literal: true

require 'pagy/countless'

class Pagy

  VARS[:countless_minimal] = false

  module Backend
    private         # the whole module is private so no problem with including it in a controller

    # Return Pagy object and items
    def pagy_countless(collection, vars={})
      pagy = Pagy::Countless.new(pagy_countless_get_vars(collection, vars))
      [ pagy, pagy_countless_get_items(collection, pagy) ]
    end

    # Sub-method called only by #pagy_countless: here for easy customization of variables by overriding
    def pagy_countless_get_vars(_collection, vars)
      pagy_set_items_from_params(vars) if defined?(UseItemsExtra)
      vars[:page] ||= params[ vars[:page_param] || VARS[:page_param] ]
      vars
    end

    # Sub-method called only by #pagy_countless: here for easy customization of record-extraction by overriding
    def pagy_countless_get_items(collection, pagy)
      # This should work with ActiveRecord, Sequel, Mongoid...
      return collection.offset(pagy.offset).limit(pagy.items) if pagy.vars[:countless_minimal]

      items      = collection.offset(pagy.offset).limit(pagy.items + 1).to_a
      items_size = items.size
      items.pop if items_size == pagy.items + 1
      # finalize may adjust pagy.items, so must be used after checking the size
      pagy.finalize(items_size)
      items
    end

  end
end
