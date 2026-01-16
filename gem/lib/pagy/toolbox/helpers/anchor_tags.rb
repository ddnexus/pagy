# frozen_string_literal: true

require_relative 'support/a_lambda' # inheritable

class Pagy
  # Return the enabled/disabled previous page anchor tag
  def previous_tag(a = nil, text: I18n.t('pagy.previous'),
                   aria_label: I18n.t('pagy.aria_label.previous'), **)
    prev_next_tag(@previous, a, text, aria_label, **)
  end

  # Return the enabled/disabled next page anchor tag
  def next_tag(a = nil, text: I18n.t('pagy.next'),
               aria_label: I18n.t('pagy.aria_label.next'), **)
    prev_next_tag(@next, a, text, aria_label, **)
  end

  private

  def prev_next_tag(page, a, text, aria_label, **)
    return (a || a_lambda(**)).(page, text, aria_label:) if page

    %(<a role="link" aria-disabled="true" aria-label="#{aria_label}">#{text}</a>)
  end
end
