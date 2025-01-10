# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/keyset
# frozen_string_literal: true

require_relative '../keyset'

class Pagy
  # Add backend methods
  Backend.class_eval do
    private

    # Return Pagy::Keyset object and paginated records
    def pagy_keyset(set, **vars)
      vars[:limit] ||= pagy_get_limit(vars)
      vars[:page]  ||= pagy_get_page(vars, force_integer: false) # allow nil
      pagy = Keyset.new(set, **vars)
      [pagy, pagy.records]
    end

    # Return the URL string for the first page
    def pagy_keyset_first_url(pagy, **vars)
      pagy_page_url(pagy, nil, **vars)
    end

    # Return the URL string for the next page or nil
    def pagy_keyset_next_url(pagy, **vars)
      pagy_page_url(pagy, pagy.next, **vars) if pagy.next
    end
  end
end
