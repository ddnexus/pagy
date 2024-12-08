# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/keyset_cached
# frozen_string_literal: true

require_relative '../keyset/ui_compatible'

class Pagy # :nodoc:
  # Add keyset UI Compatible methods
  module KeysetUICompatibleExtra
    private

    # Return Pagy::Keyset::UICompatible object and paginated records
    def pagy_keyset_ui_compatible(set, **vars)
      vars[:page]  ||= pagy_get_page(vars) # numeric page
      vars[:limit] ||= pagy_get_limit(vars)
      vars[:cache] ||= session
      # The user should assign this properly
      vars[:cache_key] ||= ->(v) { "pagy-#{v[:limit]}" }
      pagy = Keyset::UICompatible.new(set, **vars)
      [pagy, pagy.records]
    end
    alias pagy_keyset_ui pagy_keyset_ui_compatible
  end
  Backend.prepend KeysetUICompatibleExtra
end
