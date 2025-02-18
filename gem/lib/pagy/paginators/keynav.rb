# frozen_string_literal: true

require_relative '../../pagy/resources/b64'

class Pagy
  # Add keynav paginator
  module Paginators
    # Return Pagy::Keyset::Keynav object and paginated records
    def pagy_keynav_js(set, **options)
      page = pagy_get_page(options, force_integer: false) # allow nil
      if page&.match(' ')       # countless page -> no augmentation -> fallback
        return pagy_countless(set, page:, **options)
      elsif page.is_a?(String)  # keynav page param
        page_arguments = JSON.parse(B64.urlsafe_decode(page))
        # Restart the pagination from page 1 if the url has been requested from another browser
        options[:page] = page_arguments if request.cookies['pagy'] == page_arguments.shift
      end

      options[:request] ||= request
      options[:limit]     = pagy_get_limit(options)
      pagy = Keyset::Keynav.new(set, **options)
      [pagy, pagy.records]
    end
  end
end
