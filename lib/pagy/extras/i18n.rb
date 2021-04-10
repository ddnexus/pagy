# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/i18n
# frozen_string_literal: true

class Pagy
  # Use ::I18n gem
  module Frontend

    ::I18n.load_path += Dir[Pagy.root.join('locales', '*.yml')]

    # unload the pagy default constant for efficiency
    Pagy::I18n.clear.instance_eval do
      undef :load
      undef :t
    end

    module UseI18nGem
      def pagy_t(key, **opts) = ::I18n.t(key, **opts)
    end
    prepend UseI18nGem

  end
end
