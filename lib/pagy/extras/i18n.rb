# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/i18n
# frozen_string_literal: true

class Pagy
  # Use ::I18n gem
  module I18nExtra
    def pagy_t(key, **opts)
      ::I18n.t(key, **opts)
    end
  end
  Frontend.prepend I18nExtra

  # Add the pagy locales to the I18n.load_path
  ::I18n.load_path += Dir[Pagy.root.join('locales', '*.yml')]
end
