# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/i18n
# encoding: utf-8
# frozen_string_literal: true

class Pagy
  # Use ::I18n gem
  module Frontend

    ::I18n.load_path += Dir[Pagy.root.join('locales', '*.yml')]

    Pagy::I18n.clear.instance_eval { undef :load; undef :t } # unload the pagy default constant for efficiency

    alias_method :pagy_without_i18n, :pagy_t
    def pagy_t_with_i18n(*args) ::I18n.t(*args) end
    alias_method :pagy_t, :pagy_t_with_i18n

  end
end
