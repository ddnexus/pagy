# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/keyset_frontendble
# frozen_string_literal: true

require_relative '../keyset_for_ui'

class Pagy # :nodoc:
  DEFAULT[:cache_key_param] = :cache_key

  # Add keyset UI Compatible methods
  module KeysetForUIExtra
    private

    # Return Pagy::KeysetForUI object and paginated records
    def pagy_keyset_for_ui(set, **vars)
      vars[:page]      ||= pagy_get_page(vars) # numeric page
      vars[:limit]     ||= pagy_get_limit(vars)
      vars[:cache_key] ||= params[vars[:cache_key_param] || DEFAULT[:cache_key_param]] ||
                           pagy_cache_new_key
      vars[:cutoffs]   ||= pagy_cache_read(vars[:cache_key])

      pagy = KeysetForUI.new(set, **vars)
      pagy_cache_write(vars[:cache_key], pagy.cutoffs)
      [pagy, pagy.records]
    end

    # Return 1B-max random key shortened to a base 64 number that's not yet in the cache
    def pagy_cache_new_key
      cache_key = nil
      until cache_key
        key       = B64.convert(rand(1_000_000_000))
        cache_key = key unless pagy_cache_read(key)
      end
      cache_key
    end

    def pagy_cache_read(key) = session[key]

    def pagy_cache_write(key, value) = session[key] = value
  end
  Backend.prepend KeysetForUIExtra

  # Module overriding UrlHelper
  module UrlHelperOverride
    # Override UrlHelper method
    def pagy_set_query_params(page, vars, query_params)
      super
      query_params[vars[:cache_key_param].to_s] = vars[:cache_key]
    end
  end
  Frontend.prepend UrlHelperOverride
end
