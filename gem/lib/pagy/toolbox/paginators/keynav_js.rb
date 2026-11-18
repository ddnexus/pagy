# frozen_string_literal: true

require_relative '../../../pagy/modules/b64'

class Pagy
  module KeynavJsPaginator
    module_function

    def paginate(set, options)
      page = options[:request].resolve_page(force_integer: false) # allow nil

      return CountlessPaginator.paginate(set, page:, **options) if page&.match(' ')  # countless fallback

      if page.is_a?(String) && (page_arguments = Keyset.decode(page)).is_a?(Array)
        # Restart the pagination from page 1/nil if the url has been requested from another browser
        cookie         = options[:request].cookie
        options[:page] = page_arguments if cookie && cookie == page_arguments.shift
      end

      options[:limit] = options[:request].resolve_limit

      pagy = Keyset::Keynav.new(set, **options)
      [pagy, pagy.records]
    end
  end
end
