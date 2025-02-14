# frozen_string_literal: true

# Relegate internal functions. Make overriding navs easier.
class Pagy
  class_eval do
    # Compose the aria label attribute for the nav
    def nav_aria_label_attribute(aria_label: nil)
      aria_label ||= I18n.translate('pagy.aria_label.nav', count: @last)
      %(aria-label="#{aria_label}")
    end
  end
end
