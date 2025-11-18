# frozen_string_literal: true

class Pagy
  module CountlessPaginator
    module_function

    # Return Pagy object and records
    def paginate(context, collection, **options)
      context.instance_eval do
        request = Request.new(options[:request] || self.request)
        if options[:page].nil?
          page = request.resolve_page(options, force_integer: false) # accept nil and strings
          if page.is_a?(String)
            p, l = page.split(/ /, 2).map(&:to_i)
            options[:page] = p if p.positive?
            options[:last] = l if l&.positive?
          end
        end
        options[:limit] = request.resolve_limit(options)
        pagy = Offset::Countless.new(**options, request:)
        [pagy, pagy.records(collection)]
      end
    end
  end
end
