# frozen_string_literal: true

class Pagy
  # Return the enabled/disabled previous page anchor tag
  def previous_anchor(anchor_lambda = nil, text: I18n.translate('pagy.previous'),
                      aria_label: I18n.translate('pagy.aria_label.previous'), **)
    if @previous
      (anchor_lambda || anchor_lambda(**)).(@previous, text, aria_label:)
    else
      %(<a role="link" aria-disabled="true" aria-label="#{aria_label}">#{text}</a>)
    end
  end

  # Return the enabled/disabled next page anchor tag
  def next_anchor(anchor_lambda = nil, text: I18n.translate('pagy.next'),
                  aria_label: I18n.translate('pagy.aria_label.next'), **)
    if @next
      (anchor_lambda || anchor_lambda(**)).(@next, text, aria_label:)
    else
      %(<a role="link" aria-disabled="true" aria-label="#{aria_label}">#{text}</a>)
    end
  end
end
