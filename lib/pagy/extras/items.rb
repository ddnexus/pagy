# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/items

class Pagy

  # Default variables for this extra
  VARS[:items_param] = :items
  VARS[:max_items]   = 100

  # Handle a custom number of :items from params
  module Backend ; private

    alias_method :built_in_pagy_get_vars, :pagy_get_vars

    def pagy_get_vars(collection, vars)
      vars[:items] ||= (items = params[vars[:items_param] || VARS[:items_param]]) &&                           # :items from :items_param
                       [items&.to_i, vars.key?(:max_items) ? vars[:max_items] : VARS[:max_items]].compact.min  # :items capped to :max_items
      built_in_pagy_get_vars(collection, vars)
    end

  end

  module Frontend

    # this works with all Rack-based frameworks (Sinatra, Padrino, Rails, ...)
    def pagy_url_for(page, pagy)
      p_vars = pagy.vars; params = request.GET.merge(p_vars[:page_param] => page, p_vars[:items_param] => p_vars[:items], **p_vars[:params])
      "#{request.path}?#{Rack::Utils.build_nested_query(pagy_get_params(params))}#{p_vars[:anchor]}"
    end

    # return the items selector HTML. For example "Show [20] items per page"
    def pagy_items_selector(pagy, id=caller(1,1)[0].hash)
      pagy = pagy.clone; p_vars = pagy.vars; p_items = p_vars[:items]; p_vars[:items] = "#{MARKER}-items-"

      tags = %(<span id="pagy-items-#{id}">)

        tags << %(<a href="#{pagy_url_for("#{MARKER}-page-", pagy)}"></a>)
        input = %(<input type="number" min="1" max="#{p_vars[:max_items]}" value="#{p_items}" style="padding: 0; text-align: center; width: #{p_items.to_s.length+1}rem;">)
        tags << %(#{pagy_t('pagy.items.show'.freeze)} #{input} #{pagy_t('pagy.items.items'.freeze)})

      tags << %(</span><script>PagyItems('#{id}', '#{MARKER}', #{pagy.from});</script>)
    end

  end
end
