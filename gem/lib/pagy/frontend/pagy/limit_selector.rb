# frozen_string_literal: true

class Pagy
  Frontend.module_eval do
    # Return the limit selector HTML. For example "Show [20] items per page"
    def pagy_limit_selector_js(pagy, id: nil, item_name: nil)
      return '' unless pagy.vars[:requestable_limit]

      id           = %( id="#{id}") if id
      vars         = pagy.vars
      limit        = vars[:limit]
      vars[:limit] = LIMIT_TOKEN # limit token replaced in the javascript
      url_token    = pagy_page_url(pagy, PAGE_TOKEN)
      vars[:limit] = limit # restore the limit

      limit_input = %(<input name="limit" type="number" min="1" max="#{vars[:requestable_limit]}" value="#{
                      limit}" style="padding: 0; text-align: center; width: #{limit.to_s.length + 1}rem;">#{A_TAG})

      %(<span#{id} class="pagy limit-selector-js" #{
      Front.data_pagy(:sj, pagy.from, url_token)
      }><label>#{
      pagy_t('pagy.limit_selector_js',
             item_name: item_name || pagy_t('pagy.item_name', count: limit),
             limit_input:,
             count: limit)
      }</label></span>)
    end
  end
end
