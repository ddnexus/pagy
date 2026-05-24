# frozen_string_literal: true

require_relative '../../../pagy/modules/b64'

class Pagy
  module KeynavJsPaginator
    module_function

    def paginate(set, options)
      page = options[:request].resolve_page(force_integer: false) # allow nil

      return CountlessPaginator.paginate(set, page:, **options) if page&.match(' ')  # countless fallback

      if page.is_a?(String)  # keynav page param
        begin
          page_arguments = JSON.parse(B64.urlsafe_decode(page))
          # Restart the pagination from page 1/nil if the url has been requested from another browser
          options[:page] = page_arguments if options[:request].cookie == page_arguments.shift
        rescue JSON::ParserError, ArgumentError
          # Malformed page param: fall through to first page (options[:page] stays unset)
        end
      end

      options[:limit] = options[:request].resolve_limit

      pagy = Keyset::Keynav.new(set, **options)
      [pagy, pagy.records]
    end
  end
end
