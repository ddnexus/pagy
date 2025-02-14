# frozen_string_literal: true

class Pagy
  # Add countless paginator
  Paginators.module_eval do
    private

    # Return Pagy object and records
    def pagy_countless(collection, **options)
      if options[:page].nil?
        page = pagy_get_page(options, force_integer: false) # accept nil and strings
        if page.is_a?(String)
          p, l = page.split(/ /, 2).map(&:to_i)
          options[:page] = p if p.positive?
          options[:last] = l if l&.positive?
        end
      end
      options[:request] ||= request
      options[:limit]     = pagy_get_limit(options)
      pagy = Offset::Countless.new(**options)
      [pagy, pagy_countless_get_items(collection, pagy)]
    end

    # Sub-method called only by #pagy_countless: here for easy customization of record-extraction by overriding
    # You may need to override this method for collections without offset|limit
    def pagy_countless_get_items(collection, pagy)
      return collection.offset(pagy.offset).limit(pagy.limit) if pagy.options[:headless]

      fetched = collection.offset(pagy.offset).limit(pagy.limit + 1).to_a # eager load limit + 1
      pagy.finalize(fetched.size)                                         # finalize the pagy object
      fetched[0, pagy.limit]                                              # ignore the extra item
    end
  end
end
