# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/items
# frozen_string_literal: true

require 'pagy/extras/frontend_helpers'

class Pagy # :nodoc:
  DEFAULT[:items_param] = :items
  DEFAULT[:max_items]   = 100
  DEFAULT[:items_extra] = true   # extra enabled by default

  # Allow the client to request a custom number of items per page with an optional selector UI
  module ItemsExtra
    # Additions for the Backend module
    module Backend
      private

      # Set the items variable considering the params and other pagy variables
      def pagy_set_items_from_params(vars)
        return if vars[:items]                                                             # :items explicitly set
        return unless vars.key?(:items_extra) ? vars[:items_extra] : DEFAULT[:items_extra] # :items_extra is false
        return unless (items = params[vars[:items_param] || DEFAULT[:items_param]])        # no items from request params

        vars[:items] = [items.to_i, vars.key?(:max_items) ? vars[:max_items] : DEFAULT[:max_items]].compact.min
      end
    end

    # Additions for the Frontend module
    module Frontend
      ITEMS_PLACEHOLDER = '__pagy_items__'

      # Return the items selector HTML. For example "Show [20] items per page"
      def pagy_items_selector_js(pagy, pagy_id: nil, item_name: nil, i18n_key: nil, link_extra: '')
        return '' unless pagy.vars[:items_extra]

        p_id           = %( id="#{pagy_id}") if pagy_id
        p_vars         = pagy.vars
        p_items        = p_vars[:items]
        p_vars[:items] = ITEMS_PLACEHOLDER
        link           = pagy_marked_link(pagy_link_proc(pagy, link_extra: link_extra))
        p_vars[:items] = p_items # restore the items

        html  = +%(<span#{p_id} class="pagy-items-selector-js" #{pagy_json_attr pagy, :items_selector, pagy.from, link}>)
        input = %(<input type="number" min="1" max="#{p_vars[:max_items]}" value="#{
                    p_items}" style="padding: 0; text-align: center; width: #{p_items.to_s.length + 1}rem;">)
        html << pagy_t('pagy.items_selector_js', item_name: item_name || pagy_t(i18n_key || p_vars[:i18n_key], count: p_items),
                                                 items_input: input,
                                                 count: p_items)
        html << %(</span>)
      end
    end
  end
  Backend.prepend ItemsExtra::Backend
  Frontend.prepend ItemsExtra::Frontend
end
