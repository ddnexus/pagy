# frozen_string_literal: true

class Pagy
  module KeysetPaginator
    module_function

    # Return Pagy::Keyset object and paginated records
    def paginate(context, set, **options)
      context.instance_eval do
        request = Request.new(options[:request] || self.request, options)
        options[:page] ||= request.resolve_page(options, force_integer: false) # allow nil
        options[:limit]  = request.resolve_limit(options)
        pagy = Keyset.new(set, **options, request:)
        [pagy, pagy.records]
      end
    end
  end
end
