# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/items
# encoding: utf-8
# frozen_string_literal: true

require 'pagy/extras/shared'

class Pagy

  # Default variables for this extra
  VARS[:items_param] = :items
  VARS[:max_items]   = 100

  # Handle a custom number of :items from params
  module Backend ; private

    def pagy_with_items(vars)
      vars[:items] ||= (items = params[vars[:items_param] || VARS[:items_param]]) &&                           # :items from :items_param
                       [items.to_i, vars.key?(:max_items) ? vars[:max_items] : VARS[:max_items]].compact.min   # :items capped to :max_items
    end

    alias_method :pagy_get_vars_without_items, :pagy_get_vars
    def pagy_get_vars_with_items(collection, vars)
      pagy_with_items(vars)
      pagy_get_vars_without_items(collection, vars)
    end
    alias_method :pagy_get_vars, :pagy_get_vars_with_items

    # support for countless extra
    if defined?(Pagy::COUNTLESS)   # defined in the countless extra
      alias_method :pagy_countless_get_vars_without_items, :pagy_countless_get_vars
      def pagy_countless_get_vars_with_items(collection, vars)
        pagy_with_items(vars)
        pagy_countless_get_vars_without_items(collection, vars)
      end
      alias_method :pagy_countless_get_vars, :pagy_countless_get_vars_with_items
    end

  end

  module Frontend

    alias_method :pagy_url_for_without_items, :pagy_url_for
    def pagy_url_for_with_items(page, pagy)
      p_vars = pagy.vars; params = request.GET.merge(p_vars[:page_param] => page, p_vars[:items_param] => p_vars[:items]).merge!(p_vars[:params])
      "#{request.path}?#{Rack::Utils.build_nested_query(pagy_get_params(params))}#{p_vars[:anchor]}"
    end
    alias_method :pagy_url_for, :pagy_url_for_with_items

    # Return the items selector HTML. For example "Show [20] items per page"
    def pagy_items_selector(pagy, id=pagy_id)
      p_vars = pagy.vars; p_items = p_vars[:items]; p_vars[:items] = "#{MARKER}-items-"

      html = EMPTY + %(<span id="#{id}">)
        html << %(<a href="#{pagy_url_for("#{MARKER}-page-", pagy)}"></a>)
        p_vars[:items] = p_items # restore the items
        input = %(<input type="number" min="1" max="#{p_vars[:max_items]}" value="#{p_items}" style="padding: 0; text-align: center; width: #{p_items.to_s.length+1}rem;">)
        html << %(#{pagy_t('pagy.items', items_input: input, count: p_items)})
      html << %(</span>#{pagy_json_tag(:items, id, MARKER, pagy.from)})
    end

  end
end
