# frozen_string_literal: true

class Pagy
  module CountlessPaginator
    module_function

    # Return the Offset::Countless instance and records
    def paginate(collection, options)
      if options[:page].nil?
        page = options[:request].resolve_page(force_integer: false) # accept nil and strings
        if page.is_a?(String)
          p, l = page.split(/ /, 2).map(&:to_i) # decoded '+' added by the compose_page_url
          options[:page] = p if p.positive?
          options[:last] = l if l&.positive?
        end
      end
      options[:limit] = options[:request].resolve_limit
      pagy = Offset::Countless.new(**options)
      [pagy, pagy.records(collection)]
    end
  end
end
