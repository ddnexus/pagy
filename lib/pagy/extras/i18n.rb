# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/i18n

class Pagy
  # Use ::I18n gem
  module Frontend

    ::I18n.load_path << Pagy.root.join('locales', 'pagy.yml')

    # Override the built-in pagy_t
    def pagy_t(*args)
      I18n.t(*args)
    end

  end
end
