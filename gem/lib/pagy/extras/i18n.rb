# frozen_string_literal: true

class Pagy
  # Use ::I18n gem
  module I18nExtra
    # Frontend overriding for translation
    module FrontendOverride
      def pagy_t(key, **)
        ::I18n.t(key, **)
      end
    end
    Frontend.prepend I18nExtra::FrontendOverride
  end
  # Add the pagy locales to the I18n.load_path
  ::I18n.load_path += Dir[Pagy::ROOT.join('locales', '*.yml')]
end
