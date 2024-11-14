# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/countless
# frozen_string_literal: true
# You can override any of the `pagy_*` methods in your controller.

require_relative '../countless'

class Pagy # :nodoc:
  DEFAULT[:countless_minimal] = false

  # Paginate without the need of any count, saving one query per rendering
  module CountlessExtra
    private

    # Return Pagy object and records
    def pagy_countless(collection, **vars)
      vars[:limit] ||= pagy_get_limit(vars)
      vars[:page]  ||= pagy_get_page(vars)
      pagy = Countless.new(**vars)
      [pagy, pagy_countless_get_items(collection, pagy)]
    end

    # Sub-method called only by #pagy_countless: here for easy customization of record-extraction by overriding
    # You may need to override this method for collections without offset|limit
    def pagy_countless_get_items(collection, pagy)
      return collection.offset(pagy.offset).limit(pagy.limit) if pagy.vars[:countless_minimal]

      fetched = collection.offset(pagy.offset).limit(pagy.limit + 1).to_a # eager load limit + 1
      pagy.finalize(fetched.size)                                         # finalize the pagy object
      fetched[0, pagy.limit]                                              # ignore eventual extra item
    end
  end
  Backend.prepend CountlessExtra
end
