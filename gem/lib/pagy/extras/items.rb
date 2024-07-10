# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/items
# frozen_string_literal: true

require_relative 'js_tools'

class Pagy # :nodoc:
  DEFAULT[:items_param] = :items
  DEFAULT[:max_items]   = 100
  DEFAULT[:items_extra] = true   # extra enabled by default

  # Allow the client to request a custom number of items per page with an optional selector UI
  module ItemsExtra
    # Additions for the Backend module
    module BackendAddOn
      private

      # Set the items variable considering the params and other pagy variables
      def pagy_get_items(vars)
        return unless vars.key?(:items_extra) ? vars[:items_extra] : DEFAULT[:items_extra] # :items_extra is false
        return unless (items_count = pagy_get_items_param(vars))                            # no items from request params

        vars[:items] = [items_count.to_i, vars.key?(:max_items) ? vars[:max_items] : DEFAULT[:max_items]].compact.min
      end

      # Get the items count from the params
      # Overridable by the jsonapi extra
      def pagy_get_items_param(vars)
        params[vars[:items_param] || DEFAULT[:items_param]]
      end
    end
    Backend.prepend ItemsExtra::BackendAddOn

    # Additions for the Frontend module
    module FrontendAddOn
      ITEMS_TOKEN = '__pagy_items__'

      # Return the items selector HTML. For example "Show [20] items per page"
      def pagy_items_selector_js(pagy, id: nil, item_name: nil)
        return '' unless pagy.vars[:items_extra]

        id           = %( id="#{id}") if id
        vars         = pagy.vars
        items        = vars[:items]
        vars[:items] = ITEMS_TOKEN
        url_token    = pagy_url_for(pagy, PAGE_TOKEN)
        vars[:items] = items # restore the items

        items_input = %(<input name="items" type="number" min="1" max="#{vars[:max_items]}" value="#{
                          items}" style="padding: 0; text-align: center; width: #{items.to_s.length + 1}rem;">#{JSTools::A_TAG})

        %(<span#{id} class="pagy items-selector-js" #{
            pagy_data(pagy, :selector, pagy.from, url_token)
          }><label>#{
            pagy_t('pagy.items_selector_js',
                   item_name: item_name || pagy_t('pagy.item_name', count: items),
                   items_input:,
                   count: items)
          }</label></span>)
      end
    end
    Frontend.prepend ItemsExtra::FrontendAddOn
  end
end
