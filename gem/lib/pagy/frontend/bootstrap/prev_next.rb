# frozen_string_literal: true

class Pagy
  Frontend.module_eval do
    private

    def bootstrap_prev_html(pagy, a)
      if (p_prev = pagy.prev)
        %(<li class="page-item prev">#{
            a.(p_prev, pagy_t('pagy.prev'), classes: 'page-link', aria_label: pagy_t('pagy.aria_label.prev'))}</li>)
      else
        %(<li class="page-item prev disabled"><a role="link" class="page-link" aria-disabled="true" aria-label="#{
            pagy_t('pagy.aria_label.prev')}">#{pagy_t('pagy.prev')}</a></li>)
      end
    end

    def bootstrap_next_html(pagy, a)
      if (p_next = pagy.next)
        %(<li class="page-item next">#{
            a.(p_next, pagy_t('pagy.next'), classes: 'page-link', aria_label: pagy_t('pagy.aria_label.next'))}</li>)
      else
        %(<li class="page-item next disabled"><a role="link" class="page-link" aria-disabled="true" aria-label="#{
            pagy_t('pagy.aria_label.next')}">#{pagy_t('pagy.next')}</a></li>)
      end
    end
  end
end
