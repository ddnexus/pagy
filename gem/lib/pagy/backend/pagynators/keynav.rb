# frozen_string_literal: true

class Pagy
  # Add keynav methods
  Backend.module_eval do
    # Return Pagy::Keyset::Keynav object and paginated records
    def pagy_keynav_js(set, **vars)
      page = pagy_get_page(vars, force_integer: false) # allow nil
      if page&.match(' ')       # countless page -> no augmentation -> fallback
        return pagy_countless(set, **vars)
      elsif page.is_a?(String)  # keynav page param
        page_args = JSON.parse(B64.urlsafe_decode(page))
        # Restart the pagination from page 1 if the url has been requested from another browser
        vars[:page] = page_args if request.cookies['pagy'] == page_args.shift
      end

      vars[:limit] = pagy_get_limit(vars)
      pagy = Keyset::Keynav.new(set, **vars)
      [pagy, pagy.records]
    end
  end
end
