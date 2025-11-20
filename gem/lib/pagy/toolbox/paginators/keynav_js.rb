# frozen_string_literal: true

require_relative '../../../pagy/modules/b64'

class Pagy
  module KeynavJsPaginator
    module_function

    # Return the Pagy::Keyset::Keynav instance and paginated records.
    # Fall back to :countless if the :page has no client data.
    def paginate(set, options)
      page = options[:request].resolve_page(options, force_integer: false) # allow nil
      if page&.match(' ')       # countless page -> no augmentation -> fallback
        return CountlessPaginator.paginate(set, page:, **options)
      elsif page.is_a?(String)  # keynav page param
        page_arguments = JSON.parse(B64.urlsafe_decode(page))
        # Restart the pagination from page 1 if the url has been requested from another browser
        options[:page] = page_arguments if options[:request].cookie == page_arguments.shift
      end

      options[:limit] = options[:request].resolve_limit(options)
      pagy = Keyset::Keynav.new(set, **options)
      [pagy, pagy.records]
    end
  end
end
