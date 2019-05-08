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

    # add the pagy*_get_vars alias-chained methods for frontend, and defined/required extras
    [nil, 'countless', 'elasticsearch_rails', 'searchkick'].each do |name|
      prefix, if_start, if_end = "_#{name}", "if defined?(Pagy::#{name.upcase})", "end" if name
      module_eval <<-RUBY
        #{if_start}
          alias_method :pagy#{prefix}_get_vars_without_items, :pagy#{prefix}_get_vars
          def pagy#{prefix}_get_vars_with_items(collection, vars)
            pagy_with_items(vars)
            pagy#{prefix}_get_vars_without_items(collection, vars)
          end
          alias_method :pagy#{prefix}_get_vars, :pagy#{prefix}_get_vars_with_items  
        #{if_end}
      RUBY
    end

  end

  module Frontend

    alias_method :pagy_url_for_without_items, :pagy_url_for
    def pagy_url_for_with_items(page, pagy, url=false)
      p_vars = pagy.vars; params = request.GET.merge(p_vars[:params]); params[p_vars[:page_param].to_s] = page
      params[p_vars[:items_param].to_s] = p_vars[:items]
      "#{request.base_url if url}#{request.path}?#{Rack::Utils.build_nested_query(pagy_get_params(params))}#{p_vars[:anchor]}"
    end
    alias_method :pagy_url_for, :pagy_url_for_with_items

    # Return the items selector HTML. For example "Show [20] items per page"
    def pagy_items_selector_js(pagy, id=pagy_id)
      p_vars         = pagy.vars
      p_items        = p_vars[:items]
      p_vars[:items] = '__pagy_items__'
      link           = pagy_marked_link(pagy_link_proc(pagy))
      p_vars[:items] = p_items # restore the items

      html = EMPTY + %(<span id="#{id}">)
      input = %(<input type="number" min="1" max="#{p_vars[:max_items]}" value="#{p_items}" style="padding: 0; text-align: center; width: #{p_items.to_s.length+1}rem;">)
      html << %(#{pagy_t('pagy.items_selector_js', item_name: pagy_t(p_vars[:i18n_key], count: p_items), items_input: input, count: p_items)})
      html << %(</span>#{pagy_json_tag(:items_selector, id, pagy.from, link, defined?(TRIM) && p_vars[:page_param])})
    end

  end
end
