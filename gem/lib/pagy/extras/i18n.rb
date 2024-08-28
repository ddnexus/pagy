# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/i18n
# frozen_string_literal: true

class Pagy # :nodoc:
  # Use ::I18n gem
  module I18nExtra
    # Frontend overriding for translation
    module FrontendOverride
      def pagy_t(key, **opts)
        ::I18n.t(key, **opts)
      end
    end
    Frontend.prepend I18nExtra::FrontendOverride

    # Calendar overriding for localization (see also the block in the calendar section of the config/pagy.rb initializer)
    module CalendarOverride
      def localize(time, opts)
        ::I18n.l(time, **opts)
      end
    end
  end
  Calendar::Unit.prepend I18nExtra::CalendarOverride if defined?(::Pagy::Calendar::Unit)

  # Add the pagy locales to the I18n.load_path
  ::I18n.load_path += Dir[Pagy.root.join('locales', '*.yml')]
end
