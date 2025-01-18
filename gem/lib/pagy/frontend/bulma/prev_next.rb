# frozen_string_literal: true

class Pagy
  Frontend.module_eval do
    private

    def bulma_prev_next_html(pagy, a)
      html = if (p_prev = pagy.prev)
               a.(p_prev, pagy_t('pagy.prev'), classes: 'pagination-previous', aria_label: pagy_t('pagy.aria_label.prev'))
             else
               %(<a role="link" class="pagination-previous" disabled aria-disabled="true" aria-label="#{
                   pagy_t('pagy.aria_label.prev')}">#{pagy_t 'pagy.prev'}</a>)
             end
      html << if (p_next = pagy.next)
                a.(p_next, pagy_t('pagy.next'), classes: 'pagination-next', aria_label: pagy_t('pagy.aria_label.next'))
              else
                %(<a role="link" class="pagination-next" disabled aria-disabled="true" aria-label="#{
                    pagy_t('pagy.aria_label.next')}">#{pagy_t('pagy.next')}</a>)
              end
    end
  end
end
