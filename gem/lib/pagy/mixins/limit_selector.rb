# frozen_string_literal: true

require_relative '../extras/limit'

class Pagy
  # Additions for the Frontend module
  Frontend.class_eval do
    # Return the limit selector HTML. For example "Show [20] items per page"
    def pagy_limit_selector_js(pagy, id: nil, item_name: nil)
      return '' unless pagy.vars[:limit_extra]

      id           = %( id="#{id}") if id
      vars         = pagy.vars
      limit        = vars[:limit]
      vars[:limit] = LIMIT_TOKEN # limit token replaced in the javascript
      url_token    = pagy_page_url(pagy, PAGE_TOKEN)
      vars[:limit] = limit # restore the limit

      limit_input = %(<input name="limit" type="number" min="1" max="#{vars[:limit_max]}" value="#{
                      limit}" style="padding: 0; text-align: center; width: #{limit.to_s.length + 1}rem;">#{A_TAG})

      %(<span#{id} class="pagy limit-selector-js" #{
      pagy_data(pagy, :sj, pagy.from, url_token)
      }><label>#{
      pagy_t('pagy.limit_selector_js',
             item_name: item_name || pagy_t('pagy.item_name', count: limit),
             limit_input:,
             count: limit)
      }</label></span>)
    end
  end
end
