# frozen_string_literal: true

class Pagy
  # Relegate internal functions. Make overriding navs easier.
  module NavAriaLabel
    module_function

    # Compose the aria label attribute for the nav
    def attr(frontend, pagy, aria_label: nil)
      aria_label ||= frontend.pagy_t('pagy.aria_label.nav', count: pagy.pages)
      %(aria-label="#{aria_label}")
    end
  end
end
