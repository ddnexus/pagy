# frozen_string_literal: true

class Pagy
  # Add countless paginator
  module Paginators
    # Return Pagy object and records
    def pagy_countless(collection, **options)
      if options[:page].nil?
        page = pagy_get_page(options, force_integer: false) # accept nil and strings
        if page.is_a?(String)
          p, l = page.split(/ /, 2).map(&:to_i)
          options[:page] = p if p.positive?
          options[:last] = l if l&.positive?
        end
      end
      options[:request] ||= request
      options[:limit]     = pagy_get_limit(options)
      pagy = Offset::Countless.new(**options)
      [pagy, pagy.records(collection)]
    end
  end
end
