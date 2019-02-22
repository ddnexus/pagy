# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/countless
# encoding: utf-8
# frozen_string_literal: true

require 'pagy/countless'

class Pagy

  # used by the items extra
  COUNTLESS = true

  module Backend ; private         # the whole module is private so no problem with including it in a controller

    # Return Pagy object and items
    def pagy_countless(collection, vars={})
      pagy = Pagy::Countless.new(pagy_countless_get_vars(collection, vars))
      return pagy, pagy_countless_get_items(collection, pagy)
    end

    # Sub-method called only by #pagy_countless: here for easy customization of variables by overriding
    def pagy_countless_get_vars(_collection, vars)
      vars[:page] ||= params[ vars[:page_param] || VARS[:page_param] ]
      vars
    end

    # Sub-method called only by #pagy_countless: here for easy customization of record-extraction by overriding
    def pagy_countless_get_items(collection, pagy)
      # This should work with ActiveRecord, Sequel, Mongoid...
      items      = collection.offset(pagy.offset).limit(pagy.items + 1).to_a
      items_size = items.size
      items.pop if items_size == pagy.items + 1
      pagy.finalize(items_size)                  # finalize may adjust pagy.items, so must be used after checking the size
      items
    end

  end
end
