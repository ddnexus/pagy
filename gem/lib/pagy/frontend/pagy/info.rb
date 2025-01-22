# frozen_string_literal: true

class Pagy
  Frontend.module_eval do
    # Return examples: "Displaying items 41-60 of 324 in total" or "Displaying Products 41-60 of 324 in total"
    def pagy_info(pagy, id: nil, item_name: nil)
      p_count = pagy.count
      key     = if p_count.zero?
                  'pagy.info.no_items'
                elsif pagy.pages == 1
                  'pagy.info.single_page'
                else
                  'pagy.info.multiple_pages'
                end

      %(<span#{%( id="#{id}") if id} class="pagy info">#{
      pagy_t key, item_name: item_name || pagy_t('pagy.item_name', count: p_count),
                  count:     p_count,
                  from:      pagy.from,
                  to:        pagy.to
      }</span>)
    end
  end
end
