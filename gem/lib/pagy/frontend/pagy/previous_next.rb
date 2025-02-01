# frozen_string_literal: true

class Pagy
  Frontend.module_eval do
    # Return the enabled/disabled previous page anchor tag
    def pagy_previous_a(pagy, a = nil, text: pagy_translate('pagy.previous'),
                        aria_label: pagy_translate('pagy.aria_label.previous'), **)
      if pagy.previous
        (a || pagy_anchor(pagy, **)).(pagy.previous, text, aria_label:)
      else
        %(<a role="link" aria-disabled="true" aria-label="#{aria_label}">#{text}</a>)
      end
    end

    # Return the enabled/disabled next page anchor tag
    def pagy_next_a(pagy, a = nil, text: pagy_translate('pagy.next'), aria_label: pagy_translate('pagy.aria_label.next'), **)
      if pagy.next
        (a || pagy_anchor(pagy, **)).(pagy.next, text, aria_label:)
      else
        %(<a role="link" aria-disabled="true" aria-label="#{aria_label}">#{text}</a>)
      end
    end
  end
end
