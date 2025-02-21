# frozen_string_literal: true

require_relative 'support/data_pagy_attribute'

class Pagy
  # Return the limit selector HTML. For example "Show [20] items per page"
  def limit_selector_js_tag(id: nil, item_name: nil)
    raise OptionError.new(self, :requestable_limit, 'to be defined', nil) unless @options[:requestable_limit]

    url_token   = compose_page_url(PAGE_TOKEN, limit_token: LIMIT_TOKEN)
    limit_input = %(<input name="limit" type="number" min="1" max="#{@options[:requestable_limit]}" value="#{
                    @limit}" style="padding: 0; text-align: center; width: #{@limit.to_s.length + 1}rem;">#{A_TAG})

    %(<span#{%( id="#{id}") if id} class="pagy limit-selector-js" #{
      data_pagy_attribute(:sj, @from, url_token)
      }><label>#{
      I18n.translate('pagy.limit_selector_js_tag',
                     item_name: item_name || I18n.translate('pagy.item_name', count: @limit),
                     limit_input:,
                     count: @limit)
      }</label></span>)
  end
end
