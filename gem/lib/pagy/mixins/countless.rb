# frozen_string_literal: true

require_relative '../offset/countless'

class Pagy
  # Paginate without the need of any count, saving one query per rendering
  Backend.module_eval do
    private

    # Return Pagy object and records
    def pagy_countless(collection, **vars)
      if vars[:page].nil?
        page = pagy_get_page(vars, force_integer: false) # accept nil and strings
        if page.is_a?(String)
          p, l = page.split.map(&:to_i)
          vars[:page] = p
          vars[:last] = l
        else
          vars[:page] = 1
        end
      end
      vars[:limit] ||= pagy_get_limit(vars)
      pagy = Offset::Countless.new(**vars)
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
end
