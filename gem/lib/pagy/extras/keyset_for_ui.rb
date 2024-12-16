# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/keyset_frontendble
# frozen_string_literal: true

require_relative '../keyset_for_ui'
require_relative 'js_tools'

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
      cutoffs, cutoff_vars = pagy_get_cutoff_and_vars(vars)
      vars[:cutoffs] = cutoff_vars
      pagy = KeysetForUI.new(set, **vars)
      # if last known page & not the last set page
      if vars[:page] == cutoff_vars[0] && (cutoff = pagy.cutoff)
        cutoffs.push(cutoff)
      end
      pagy_cache_write(vars[:cache_key], cutoffs) # adds the updated
      [pagy, pagy.records]
    end

    def pagy_get_cutoff_and_vars(vars)
      cutoffs = pagy_cache_read(vars[:cache_key]) || [nil]  # cutoffs keyed by page number, so [0] is never used
      pages   = cutoffs.size  # the page size is the number of the cutoffs so far
      page    = vars[:page]
      if page > pages
        raise OverflowError.new(self, :page, "in 1..#{pages}", page) \
              unless DEFAULT[:reset_overflow] || vars[:reset_overflow]

        # reset pagination (TODO: check if it's ok moved here)
        page    = 1
        cutoffs = [nil]
      end
      # cutoff_vars:
      # [0] last/pages:  known cutoff size (pages/last): 1 when none (i.e. page #1)
      # [1] prev_cutoff: nil for page 1 (i.e. begins from begin of set)
      # [2] cutoff:      known page; nil for last page
      [cutoffs, [pages, cutoffs[page - 1], cutoffs[page]]]
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

    def pagy_cache_push(key, cutoff)
      cutoffs = pagy_cache_read(key).push(cutoff)
      pagy_cache_write(key, cutoffs)
    end

    def pagy_cache_read(key) = session[key]

    def pagy_cache_write(key, value) = session[key] = value
  end
  Backend.prepend KeysetForUIExtra

  # Module overriding UrlHelper
  module UrlHelpersOverride
    # Override UrlHelper method
    def pagy_set_query_params(page, vars, query_params)
      super
      query_params[vars[:cache_key_param].to_s] = vars[:cache_key]
    end
  end
  UrlHelpers.prepend UrlHelpersOverride

  # Add the cutoff to the pagy_data
  module JSToolsOverride
    def pagy_data(pagy, *args)
      args << { cutoff: pagy.cutoff } if pagy.is_a?(::Pagy::KeysetForUi)
      super
    end
  end
  JSTools.prepend JSToolsOverride
end
