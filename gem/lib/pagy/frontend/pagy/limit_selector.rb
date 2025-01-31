# frozen_string_literal: true

require_relative '../utils/data_pagy'

class Pagy
  Frontend.module_eval do
    # Return the limit selector HTML. For example "Show [20] items per page"
    def pagy_limit_selector_js(pagy, id: nil, item_name: nil)
      return '' unless pagy.options[:requestable_limit]

      options     = pagy.options
      limit       = options[:limit]
      url_token   = pagy_page_url(pagy, PAGE_TOKEN, limit_token: LIMIT_TOKEN)
      limit_input = %(<input name="limit" type="number" min="1" max="#{options[:requestable_limit]}" value="#{
                       limit}" style="padding: 0; text-align: center; width: #{limit.to_s.length + 1}rem;">#{A_TAG})

      %(<span#{%( id="#{id}") if id} class="pagy limit-selector-js" #{
      DataPagy.attr(:sj, pagy.from, url_token)
      }><label>#{
      pagy_t('pagy.limit_selector_js',
             item_name: item_name || pagy_t('pagy.item_name', count: limit),
             limit_input:,
             count: limit)
      }</label></span>)
    end
  end
end
