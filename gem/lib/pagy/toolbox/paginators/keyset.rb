# frozen_string_literal: true

class Pagy
  module KeysetPaginator
    module_function

    # Return Pagy::Keyset instance and paginated records
    def paginate(set, options)
      options[:page] ||= options[:request].resolve_page(options, force_integer: false) # allow nil
      options[:limit]  = options[:request].resolve_limit(options)
      pagy = Keyset.new(set, **options)
      [pagy, pagy.records]
    end
  end
end
