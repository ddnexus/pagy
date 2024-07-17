# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/limit
# frozen_string_literal: true

require_relative 'js_tools'

class Pagy # :nodoc:
  DEFAULT[:limit_param] = :limit
  DEFAULT[:max_limit]   = 100
  DEFAULT[:limit_extra] = true   # extra enabled by default

  # Allow the client to request a custom limit per page with an optional selector UI
  module LimitExtra
    # Additions for the Backend module
    module BackendAddOn
      private

      # Set the limit variable considering the params and other pagy variables
      def pagy_get_limit(vars)
        return unless vars.key?(:limit_extra) ? vars[:limit_extra] : DEFAULT[:limit_extra] # :limit_extra is false
        return unless (limit_count = pagy_get_limit_param(vars))                            # no limit from request params

        vars[:limit] = [limit_count.to_i, vars.key?(:max_limit) ? vars[:max_limit] : DEFAULT[:max_limit]].compact.min
      end

      # Get the limit count from the params
      # Overridable by the jsonapi extra
      def pagy_get_limit_param(vars)
        params[vars[:limit_param] || DEFAULT[:limit_param]]
      end
    end
    Backend.prepend LimitExtra::BackendAddOn

    # Additions for the Frontend module
    module FrontendAddOn
      LIMIT_TOKEN = '__pagy_limit__'

      # Return the limit selector HTML. For example "Show [20] items per page"
      def pagy_limit_selector_js(pagy, id: nil, item_name: nil)
        return '' unless pagy.vars[:limit_extra]

        id           = %( id="#{id}") if id
        vars         = pagy.vars
        limit        = vars[:limit]
        vars[:limit] = LIMIT_TOKEN
        url_token    = pagy_url_for(pagy, PAGE_TOKEN)
        vars[:limit] = limit # restore the limit

        limit_input = %(<input name="limit" type="number" min="1" max="#{vars[:max_limit]}" value="#{
                          limit}" style="padding: 0; text-align: center; width: #{limit.to_s.length + 1}rem;">#{JSTools::A_TAG})

        %(<span#{id} class="pagy limit-selector-js" #{
            pagy_data(pagy, :selector, pagy.from, url_token)
          }><label>#{
            pagy_t('pagy.limit_selector_js',
                   item_name: item_name || pagy_t('pagy.item_name', count: limit),
                   limit_input:,
                   count: limit)
          }</label></span>)
      end
    end
    Frontend.prepend LimitExtra::FrontendAddOn
  end
end
