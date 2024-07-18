# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/countless
# frozen_string_literal: true

require_relative '../countless'

class Pagy # :nodoc:
  DEFAULT[:countless_minimal] = false

  # Paginate without the need of any count, saving one query per rendering
  module CountlessExtra
    private

    # Return Pagy object and records
    def pagy_countless(collection, **vars)
      pagy = Countless.new(**pagy_countless_get_vars(collection, vars))
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

    # Sub-method called only by #pagy: here for easy customization of variables by overriding
    # You may need to override the count call for non AR collections
    def pagy_countless_get_vars(_collection, vars)
      vars.tap do |v|
        v[:limit] ||= pagy_get_limit(v)
        v[:page]  ||= pagy_get_page(v)
      end
    end
  end
  Backend.prepend CountlessExtra
end
