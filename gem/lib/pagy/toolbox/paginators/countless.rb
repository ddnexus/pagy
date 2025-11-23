# frozen_string_literal: true

class Pagy
  module CountlessPaginator
    module_function

    # Return the Offset::Countless instance and records
    def paginate(collection, options)
      options[:page] ||= options[:request].resolve_page(force_integer: false) # accept nil and strings
      if options[:page].is_a?(String)
        page, last     = options[:page].split(/ /, 2).map(&:to_i) # decoded '+' added by the compose_page_url
        options[:page] = page
        if last&.positive?
          options[:last] = last
        else
          # Legacy, last-less page links are handled by starting from the first page
          options[:page] = nil
        end
      end
      options[:limit] = options[:request].resolve_limit
      pagy            = Offset::Countless.new(**options)
      [pagy, pagy.records(collection)]
    end
  end
end
