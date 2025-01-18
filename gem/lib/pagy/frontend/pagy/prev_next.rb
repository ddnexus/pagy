# frozen_string_literal: true

class Pagy
  Frontend.module_eval do
    # Conditionally return the previous page link tag
    def pagy_prev_a(pagy, a = nil, text: pagy_t('pagy.prev'), aria_label: pagy_t('pagy.aria_label.prev'), **vars)
      if (p_prev = pagy.prev)
        (a || pagy_anchor(pagy, **vars)).(p_prev, text, aria_label:)
      else
        %(<a role="link" aria-disabled="true" aria-label="#{aria_label}">#{text}</a>)
      end
    end

    # Return the enabled/disabled next page anchor tag
    def pagy_next_a(pagy, a = nil, text: pagy_t('pagy.next'), aria_label: pagy_t('pagy.aria_label.next'), **vars)
      if (p_next = pagy.next)
        (a || pagy_anchor(pagy, **vars)).(p_next, text, aria_label:)
      else
        %(<a role="link" aria-disabled="true" aria-label="#{aria_label}">#{text}</a>)
      end
    end
  end
end
