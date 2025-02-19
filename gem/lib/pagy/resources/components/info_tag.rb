# frozen_string_literal: true

class Pagy
  # Return examples: "Displaying items 41-60 of 324 in total" or "Displaying Products 41-60 of 324 in total"
  def info_tag(id: nil, item_name: nil)
    key = if @count.zero?
            'pagy.info_tag.no_items'
          elsif @last == 1
            'pagy.info_tag.single_page'
          else
            'pagy.info_tag.multiple_pages'
          end
    %(<span#{%( id="#{id}") if id} class="pagy info">#{
    I18n.translate key,
                   item_name: item_name || I18n.translate('pagy.item_name', count: @count),
                   count:     @count,
                   from:      @from,
                   to:        @to
    }</span>)
  end
end
