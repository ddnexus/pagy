# frozen_string_literal: true

class Pagy
  Frontend.module_eval do
    # Return the enabled/disabled previous page anchor tag
    def pagy_previous_anchor(pagy, create_anchor = nil, text: pagy_translate('pagy.previous'),
                             aria_label: pagy_translate('pagy.aria_label.previous'), **)
      if pagy.previous
        (create_anchor || pagy_create_anchor_lambda(pagy, **)).(pagy.previous, text, aria_label:)
      else
        %(<a role="link" aria-disabled="true" aria-label="#{aria_label}">#{text}</a>)
      end
    end

    # Return the enabled/disabled next page anchor tag
    def pagy_next_anchor(pagy, create_anchor = nil, text: pagy_translate('pagy.next'),
                         aria_label: pagy_translate('pagy.aria_label.next'), **)
      if pagy.next
        (create_anchor || pagy_create_anchor_lambda(pagy, **)).(pagy.next, text, aria_label:)
      else
        %(<a role="link" aria-disabled="true" aria-label="#{aria_label}">#{text}</a>)
      end
    end
  end
end
