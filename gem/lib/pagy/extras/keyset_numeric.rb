# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/keyset_frontendble
# frozen_string_literal: true

require_relative '../keyset/numeric'

class Pagy # :nodoc:
  # Add keyset UI Compatible methods
  module KeysetNumericExtra
    private

    # Return Pagy::Keyset::Numeric object and paginated records
    def pagy_keyset_numeric(set, **vars)
      vars[:page]  ||= pagy_get_page(vars) # numeric page
      vars[:limit] ||= pagy_get_limit(vars)
      vars[:cache] ||= session
      pagy = Keyset::Numeric.new(set, **vars)
      [pagy, pagy.records]
    end
  end
  Backend.prepend KeysetNumericExtra
end
