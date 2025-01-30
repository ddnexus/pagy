# frozen_string_literal: true

class Pagy
  # Add backend methods
  Backend.module_eval do
    private

    # Return Pagy::Keyset object and paginated records
    def pagy_keyset(set, **opts)
      opts[:limit]   = pagy_get_limit(opts)
      opts[:page]  ||= pagy_get_page(opts, force_integer: false) # allow nil
      pagy = Keyset.new(set, **opts)
      [pagy, pagy.records]
    end

    # Return the URL string for the first page
    def pagy_keyset_first_url(pagy, **)
      pagy_page_url(pagy, nil, **)
    end

    # Return the URL string for the next page or nil
    def pagy_keyset_next_url(pagy, **)
      pagy_page_url(pagy, pagy.next, **) if pagy.next
    end
  end
end
