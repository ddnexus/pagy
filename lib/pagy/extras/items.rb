# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/items
# frozen_string_literal: true

require 'pagy/extras/shared'

class Pagy

  # Default variables for this extra
  VARS[:items_param] = :items
  VARS[:max_items]   = 100

  ITEMS_PLACEHOLDER = '__pagy_items__'

  module UseItemsExtra
    private

    %i[ pagy_get_vars
        pagy_countless_get_vars
        pagy_elasticsearch_rails_get_vars
        pagy_searchkick_get_vars
    ].each do |meth|
      next unless Backend.private_method_defined?(meth, true)

      define_method(meth) do |collection, vars|
        vars[:items] ||= if (items = params[vars[:items_param] || VARS[:items_param]])                             # :items from :items_param
                           [items.to_i, vars.key?(:max_items) ? vars[:max_items] : VARS[:max_items]].compact.min   # :items capped to :max_items
                         end
        super collection, vars
      end
    end

  end
  Backend.prepend UseItemsExtra


  module Frontend

    module UseItemsExtra

      def pagy_url_for(pagy, page, url=nil)
        pagy, page = Pagy.deprecated_order(pagy, page) if page.is_a?(Pagy)
        p_vars = pagy.vars
        params = request.GET.merge(p_vars[:params])
        params[p_vars[:page_param].to_s]  = page
        params[p_vars[:items_param].to_s] = p_vars[:items]
        "#{request.base_url if url}#{request.path}?#{Rack::Utils.build_nested_query(pagy_get_params(params))}#{p_vars[:anchor]}"
      end

    end
    prepend UseItemsExtra

    # Return the items selector HTML. For example "Show [20] items per page"
    def pagy_items_selector_js(pagy, deprecated_id=nil, pagy_id: nil, item_name: nil, i18n_key: nil)
      pagy_id        = Pagy.deprecated_arg(:id, deprecated_id, :pagy_id, pagy_id) if deprecated_id
      p_id           = %( id="#{pagy_id}") if pagy_id
      p_vars         = pagy.vars
      p_items        = p_vars[:items]
      p_vars[:items] = ITEMS_PLACEHOLDER
      link           = pagy_marked_link(pagy_link_proc(pagy))
      p_vars[:items] = p_items # restore the items

      html  = %(<span#{p_id}>)
      input = %(<input type="number" min="1" max="#{p_vars[:max_items]}" value="#{p_items}" style="padding: 0; text-align: center; width: #{p_items.to_s.length+1}rem;">)
      html << pagy_t('pagy.items_selector_js', item_name: item_name || pagy_t(i18n_key || p_vars[:i18n_key], count: p_items),
                                               items_input: input,
                                               count:       p_items)
      html << %(</span>#{pagy_json_tag pagy, :items_selector, pagy.from, link})
    end

  end
end
