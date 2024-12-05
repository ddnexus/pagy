# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/keyset_cached
# frozen_string_literal: true

require_relative '../keyset/cached'

class Pagy # :nodoc:
  # Add keyset for UI methods
  module KeysetCachedExtra
    private

    # Return Pagy::Keyset::Cached object and paginated records
    def pagy_keyset_cached(set, **vars)
      vars[:page]  ||= pagy_get_page(vars) # numeric page
      vars[:limit] ||= pagy_get_limit(vars)
      vars[:cache] ||= session
      # The user should assign this properly
      vars[:cache_key] ||= ->(v) { "pagy-#{v[:limit]}" }
      pagy = Keyset::Cached.new(set, **vars)
      [pagy, pagy.records]
    end
  end
  Backend.prepend KeysetCachedExtra
end
