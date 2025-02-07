# frozen_string_literal: true

class Pagy
  Frontend.module_eval do
    # Return the enabled/disabled previous page anchor tag
    def pagy_previous_anchor(pagy, anchor_lambda = nil, text: pagy_translate('pagy.previous'),
                             aria_label: pagy_translate('pagy.aria_label.previous'), **)
      if pagy.previous
        (anchor_lambda || pagy_anchor_lambda(pagy, **)).(pagy.previous, text, aria_label:)
      else
        %(<a role="link" aria-disabled="true" aria-label="#{aria_label}">#{text}</a>)
      end
    end

    # Return the enabled/disabled next page anchor tag
    def pagy_next_anchor(pagy, anchor_lambda = nil, text: pagy_translate('pagy.next'),
                         aria_label: pagy_translate('pagy.aria_label.next'), **)
      if pagy.next
        (anchor_lambda || pagy_anchor_lambda(pagy, **)).(pagy.next, text, aria_label:)
      else
        %(<a role="link" aria-disabled="true" aria-label="#{aria_label}">#{text}</a>)
      end
    end
  end
end
