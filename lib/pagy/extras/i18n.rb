# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/i18n
# frozen_string_literal: true

class Pagy
  # Use ::I18n gem
  module Frontend

    ::I18n.load_path += Dir[Pagy.root.join('locales', '*.yml')]

    I18N.replace({}).instance_eval { undef :load } # unload the pagy constant (loaded by default)

    # no :pagy_without_i18n alias with the i18n gem
    def pagy_t_with_i18n(*args)
      ::I18n.t(*args)
    end
    alias :pagy_t :pagy_t_with_i18n

  end
end
