# frozen_string_literal: true

class Pagy
  # Paginate without the need of any count, saving one query per rendering
  Backend.module_eval do
    private

    # Return Pagy object and records
    def pagy_countless(collection, **opts)
      if opts[:page].nil?
        page = pagy_get_page(opts, force_integer: false) # accept nil and strings
        if page.is_a?(String)
          p, l = page.split(/ /, 2).map(&:to_i)
          opts[:page] = p if p.positive?
          opts[:last] = l if l&.positive?
        end
      end
      opts[:limit] = pagy_get_limit(opts)
      pagy = Offset::Countless.new(**opts)
      [pagy, pagy_countless_get_items(collection, pagy)]
    end

    # Sub-method called only by #pagy_countless: here for easy customization of record-extraction by overriding
    # You may need to override this method for collections without offset|limit
    def pagy_countless_get_items(collection, pagy)
      return collection.offset(pagy.offset).limit(pagy.limit) if pagy.opts[:countless_minimal]

      fetched = collection.offset(pagy.offset).limit(pagy.limit + 1).to_a # eager load limit + 1
      pagy.finalize(fetched.size)                                         # finalize the pagy object
      fetched[0, pagy.limit]                                              # ignore the extra item
    end
  end
end
