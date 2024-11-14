# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/keyset
# frozen_string_literal: true
# You can override any of the `pagy_*` methods in your controller.

require_relative '../keyset'

class Pagy # :nodoc:
  # Add keyset pagination
  module KeysetExtra
    private

    # Return Pagy::Keyset object and paginated records
    def pagy_keyset(set, **vars)
      vars[:page]  ||= pagy_get_page(vars, force_integer: false) # allow nil
      vars[:limit] ||= pagy_get_limit(vars)
      pagy = Keyset.new(set, **vars)
      [pagy, pagy.records]
    end

    # Return the URL string for the first page
    def pagy_keyset_first_url(pagy, **vars)
      pagy_url_for(pagy, nil, **vars)
    end

    # Return the URL string for the next page or nil
    def pagy_keyset_next_url(pagy, **vars)
      pagy_url_for(pagy, pagy.next, **vars) if pagy.next
    end
  end
  Backend.prepend KeysetExtra
end
