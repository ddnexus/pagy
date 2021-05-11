# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/items
# frozen_string_literal: true

require 'pagy/extras/shared'

class Pagy

  # Default variables for this extra
  VARS[:items_param] = :items
  VARS[:max_items]   = 100

  VARS[:enable_items_extra] = true

  ITEMS_PLACEHOLDER = '__pagy_items__'

  module UseItemsExtra; end

  module Backend
    private

      def pagy_set_items_from_params(vars)
        return if vars[:items]
        return unless vars.key?(:enable_item_extra) ? vars[:enable_item_extra] : VARS[:enable_items_extra]
        return unless (items = params[vars[:items_param] || VARS[:items_param]])                               # :items from :items_param
        vars[:items] = [items.to_i, vars.key?(:max_items) ? vars[:max_items] : VARS[:max_items]].compact.min   # :items capped to :max_items
      end

  end

  module Frontend

    # Return the items selector HTML. For example "Show [20] items per page"
    def pagy_items_selector_js(pagy, deprecated_id=nil, pagy_id: nil, item_name: nil, i18n_key: nil, link_extra: '')
      return '' unless pagy.vars[:enable_items_extra]
      pagy_id        = Pagy.deprecated_arg(:id, deprecated_id, :pagy_id, pagy_id) if deprecated_id
      p_id           = %( id="#{pagy_id}") if pagy_id
      p_vars         = pagy.vars
      p_items        = p_vars[:items]
      p_vars[:items] = ITEMS_PLACEHOLDER
      link           = pagy_marked_link(pagy_link_proc(pagy, link_extra: link_extra))
      p_vars[:items] = p_items # restore the items

      html  = %(<span#{p_id} class="pagy-items-selector-js" #{pagy_json_attr pagy, :items_selector, pagy.from, link}>)
      input = %(<input type="number" min="1" max="#{p_vars[:max_items]}" value="#{p_items}" style="padding: 0; text-align: center; width: #{p_items.to_s.length+1}rem;">)
      html << pagy_t('pagy.items_selector_js', item_name:   item_name || pagy_t(i18n_key || p_vars[:i18n_key], count: p_items),
                                               items_input: input,
                                               count:       p_items)
      html << %(</span>)
    end

  end
end
