# frozen_string_literal: true

require_relative 'support/a_lambda' # inheritable

class Pagy
  # Return the enabled/disabled previous page anchor tag
  def previous_a_tag(a = nil, text: I18n.translate('pagy.previous'),
                     aria_label: I18n.translate('pagy.aria_label.previous'), **)
    if @previous
      (a || a_lambda(**)).(@previous, text, aria_label:)
    else
      %(<a role="link" aria-disabled="true" aria-label="#{aria_label}">#{text}</a>)
    end
  end

  # Return the enabled/disabled next page anchor tag
  def next_a_tag(a = nil, text: I18n.translate('pagy.next'),
                 aria_label: I18n.translate('pagy.aria_label.next'), **)
    if @next
      (a || a_lambda(**)).(@next, text, aria_label:)
    else
      %(<a role="link" aria-disabled="true" aria-label="#{aria_label}">#{text}</a>)
    end
  end
end
