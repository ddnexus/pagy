# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/limit
# frozen_string_literal: true

class Pagy
  DEFAULT[:limit_sym]   = :limit
  DEFAULT[:limit_max]   = 100
  DEFAULT[:limit_extra] = true   # extra enabled by default

  # Allow the client to request a custom limit per page
  # with an optional selector UI
  module LimitExtra
    # Additions for the Backend module
    module BackendAddOn
      private

      # Set the limit variable considering the params and other pagy variables
      def pagy_get_limit(vars)
        return super unless vars.key?(:limit_extra) ? vars[:limit_extra] : DEFAULT[:limit_extra]  # :limit_extra is false
        return super unless (limit_count = pagy_get_limit_param(vars))                            # no limit from request params

        vars[:limit] = [limit_count.to_i, vars.key?(:limit_max) ? vars[:limit_max] : DEFAULT[:limit_max]].compact.min
      end

      # Get the limit count from the params
      # Overridable by the jsonapi extra
      def pagy_get_limit_param(vars)
        params[vars[:limit_sym] || DEFAULT[:limit_sym]]
      end
    end
    Backend.prepend LimitExtra::BackendAddOn
  end
end
