# frozen_string_literal: true

class Pagy
  # Frontend modules are specially optimized for performance.
  Frontend.class_eval do
    def prev_a(pagy, a, text: pagy_t('pagy.prev'), aria_label: pagy_t('pagy.aria_label.prev'))
      if (p_prev = pagy.prev)
        a.(p_prev, text, aria_label:)
      else
        %(<a role="link" aria-disabled="true" aria-label="#{aria_label}">#{text}</a>)
      end
    end

    def next_a(pagy, a, text: pagy_t('pagy.next'), aria_label: pagy_t('pagy.aria_label.next'))
      if (p_next = pagy.next)
        a.(p_next, text, aria_label:)
      else
        %(<a role="link" aria-disabled="true" aria-label="#{aria_label}">#{text}</a>)
      end
    end
  end
end
