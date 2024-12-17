# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/keyset_frontendble
# frozen_string_literal: true

require_relative '../keyset_for_ui'
require_relative 'js_tools'

class Pagy # :nodoc:
  DEFAULT[:cutoffs_param] = :cutoffs
  CUTOFFS_TOKEN           = '__pagy_cutoffs__'

  # Add keyset UI Compatible methods
  module KeysetForUIExtra
    private

    # Return Pagy::KeysetForUI object and paginated records
    def pagy_keyset_for_ui(set, **vars)
      vars[:page]          ||= pagy_get_page(vars) # numeric page
      vars[:limit]         ||= pagy_get_limit(vars)
      vars[:cutoffs_param] ||= DEFAULT[:cutoffs_param]
      vars[:params]        ||= { vars[:cutoffs_param] => CUTOFFS_TOKEN } # replaced on the client side
      vars[:cutoffs]       ||= begin
                                 cutoffs = params[vars[:cutoffs_param]]
                                 JSON.parse(B64.urlsafe_decode(cutoffs)) if cutoffs
                               end
      pagy = KeysetForUI.new(set, **vars)
      [pagy, pagy.records]
    end
  end
  Backend.prepend KeysetForUIExtra

  # Add the update to the pagy_data
  module JSToolsOverride
    def pagy_data(pagy, *args)
      if pagy.is_a?(::Pagy::KeysetForUi)
        opts = args.last
        if opts.is_a?(::Hash)
          opts[:update] = pagy.update
        else
          args << { update: pagy.update }
        end
      end
      super
    end
  end
  Frontend.prepend JSToolsOverride
end
