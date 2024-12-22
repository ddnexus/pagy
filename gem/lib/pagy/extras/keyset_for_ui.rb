# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/keyset_frontendble
# frozen_string_literal: true

require_relative '../keyset_for_ui'
require_relative 'js_tools'

class Pagy # :nodoc:
  DEFAULT[:cutoffs_param] = :cutoffs

  # Add keyset UI Compatible methods
  module KeysetForUIExtra
    private

    # Return Pagy::KeysetForUI object and paginated records
    def pagy_keyset_for_ui(set, **vars)
      vars[:page]          ||= pagy_get_page(vars) # numeric page
      vars[:limit]         ||= pagy_get_limit(vars)
      vars[:cutoffs_param] ||= DEFAULT[:cutoffs_param]
      vars[:params]        ||= ->(params) { params.tap { |p| p.delete(vars[:cutoffs_param].to_s) } }
      vars[:cutoffs]       ||= get_cutoffs(vars)
      pagy = KeysetForUI.new(set, **vars)
      [pagy, pagy.records]
    end

    def get_cutoffs(vars)
      cutoffs = params[vars[:cutoffs_param]] || return

      cutoffs = JSON.parse(B64.urlsafe_decode(cutoffs))
      pagy_id = cutoffs.shift
      return cutoffs if request.cookies['pagy'] == pagy_id

      # The url has been requested from another browser, which does not have the same sessionStorage,
      # hence we need to restart the pagination to page 1
      vars[:page] = 1
      KeysetForUI::FIRST_PAGE
    end
  end
  Backend.prepend KeysetForUIExtra

  # Add the update to the pagy_data
  module DataHelperOverride
    def pagy_data(pagy, *args)
      if pagy.is_a?(::Pagy::KeysetForUI)
        opts = args.last
        if opts.is_a?(::Hash)
          opts[:update]        = pagy.update
          opts[:cutoffs_param] = pagy.vars[:cutoffs_param]
          opts[:page_param]    = pagy.vars[:page_param]
        else
          args << { update:        pagy.update,
                    cutoffs_param: pagy.vars[:cutoffs_param],
                    page_param:    pagy.vars[:page_param] }
        end
      end
      super
    end
  end
  Frontend.prepend DataHelperOverride
end
