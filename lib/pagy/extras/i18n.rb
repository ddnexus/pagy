# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/i18n
# encoding: utf-8
# frozen_string_literal: true

class Pagy
  # Use ::I18n gem
  module Frontend

    ::I18n.load_path += Dir[Pagy.root.join('locales', '*.yml')]

    Pagy::I18n.clear.instance_eval { undef :load; undef :t } # unload the pagy default constant for efficiency

    module UseI18nGem
      def pagy_t(key, **opts) = ::I18n.t(key, **opts)
    end
    prepend UseI18nGem

  end
end
