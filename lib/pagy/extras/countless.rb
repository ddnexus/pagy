# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/countless
# frozen_string_literal: true

require 'pagy/countless'

class Pagy # :nodoc:
  DEFAULT[:countless_minimal] = false

  # Paginate without the need of any count, saving one query per rendering
  module CountlessExtra
    private

    # Return Pagy object and items
    def pagy_countless(collection, vars = {})
      pagy = Countless.new(pagy_countless_get_vars(collection, vars))
      [pagy, pagy_countless_get_items(collection, pagy)]
    end

    # Sub-method called only by #pagy_countless: here for easy customization of variables by overriding
    def pagy_countless_get_vars(_collection, vars)
      pagy_set_items_from_params(vars) if defined?(ItemsExtra)
      vars[:page] ||= params[vars[:page_param] || DEFAULT[:page_param]]
      vars
    end

    # Sub-method called only by #pagy_countless: here for easy customization of record-extraction by overriding
    # You may need to override this method for collections without offset|limit
    def pagy_countless_get_items(collection, pagy)
      return collection.offset(pagy.offset).limit(pagy.items) if pagy.vars[:countless_minimal]

      fetched = collection.offset(pagy.offset).limit(pagy.items + 1).to_a # eager load items + 1
      pagy.finalize(fetched.size)                                         # finalize the pagy object
      fetched[0, pagy.items]                                              # ignore eventual extra item
    end
  end
  Backend.prepend CountlessExtra
end
