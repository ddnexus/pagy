# frozen_string_literal: true

class Pagy
  module KeysetPaginator
    module_function

    # Return Pagy::Keyset object and paginated records
    def paginate(context, set, **options)
      context.instance_eval do
        options[:request] ||= Get.hash_from(request)
        options[:page]    ||= Get.page_from(params, options, force_integer: false) # allow nil
        options[:limit]     = Get.limit_from(params, options)
        pagy = Keyset.new(set, **options)
        [pagy, pagy.records]
      end
    end
  end
end
