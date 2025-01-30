# frozen_string_literal: true

require_relative '../../../pagy/modules/b64'

class Pagy
  # Add keynav methods
  Backend.module_eval do
    # Return Pagy::Keyset::Keynav object and paginated records
    def pagy_keynav_js(set, **opts)
      page = pagy_get_page(opts, force_integer: false) # allow nil
      if page&.match(' ')       # countless page -> no augmentation -> fallback
        return pagy_countless(set, **opts)
      elsif page.is_a?(String)  # keynav page param
        page_args = JSON.parse(B64.urlsafe_decode(page))
        # Restart the pagination from page 1 if the url has been requested from another browser
        opts[:page] = page_args if request.cookies['pagy'] == page_args.shift
      end

      opts[:limit] = pagy_get_limit(opts)
      pagy = Keyset::Keynav.new(set, **opts)
      [pagy, pagy.records]
    end
  end
end
