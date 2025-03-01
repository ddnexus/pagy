# frozen_string_literal: true

require_relative '../../../pagy/modules/b64'

class Pagy
  module KeynavJsPaginator
    module_function

    # Return Pagy::Keyset::Keynav object and paginated records.
    # Fall back to :countless if the :page has no client data.
    def paginate(context, set, **options)
      context.instance_eval do
        page = Get.page_from(params, options, force_integer: false) # allow nil
        if page&.match(' ')       # countless page -> no augmentation -> fallback
          return pagy(:countless, set, page:, **options)
        elsif page.is_a?(String)  # keynav page param
          page_arguments = JSON.parse(B64.urlsafe_decode(page))
          # Restart the pagination from page 1 if the url has been requested from another browser
          options[:page] = page_arguments if request.cookies['pagy'] == page_arguments.shift
        end

        options[:request] ||= Get.hash_from(request)
        options[:limit]     = Get.limit_from(params, options)
        pagy = Keyset::Keynav.new(set, **options)
        [pagy, pagy.records]
      end
    end
  end
end
