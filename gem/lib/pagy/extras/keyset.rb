# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/keyset
# frozen_string_literal: true

require_relative '../keyset'

class Pagy # :nodoc:
  # Add keyset pagination
  module KeysetExtra
    private

    # Return Pagy::Keyset object and paginated records
    def pagy_keyset(scope, **vars)
      pagy = Keyset.new(scope, **pagy_keyset_get_vars(vars))
      [pagy, pagy.records]
    end

    # Sub-method called only by #pagy_keyset: here for easy customization of variables by overriding
    def pagy_keyset_get_vars(vars)
      vars.tap do |v|
        v[:page]  ||= pagy_get_page(v)
        v[:items] ||= pagy_get_items(v)
      end
    end
  end
  Backend.prepend KeysetExtra
end